import 'dart:async';
import 'dart:io';
import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/network_module/api_base.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart';
import 'api_exceptions.dart';

class HttpClient {
  static final HttpClient _singleton = HttpClient();
  static HttpClient get instance => _singleton;

  Future<dynamic> fetchData(String url, {Map<String, String> params}) async {
    var responseJson;
    var uri = APIBase.baseURL +
        url +
        ((params != null) ? queryParameters(params) : "");
    final token = await Prefs.token;
    final header = {
      HttpHeaders.contentTypeHeader: 'application/json'};
    try {
      final response = await http
          .get(Uri.parse(uri), headers: header)
          .timeout( const Duration(seconds: 30), onTimeout: () {
        EasyLoading.dismiss();
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      responseJson = _returnResponse(response);
    } on SocketException {
      EasyLoading.dismiss();
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print("$e");
    }
    return responseJson;
  }

  String queryParameters(Map<String, String> params) {
    if (params != null) {
      final jsonString = Uri(queryParameters: params);
      return '?${jsonString.query}';
    }
    return '';
  }

  Future<dynamic> postData(String url, dynamic body, Map<String, String> headers,
      {Map<String, String> params}) async {
    var responseJson;

    var uri = APIBase.baseURL +
        url +
        ((params != null) ? queryParameters(params) : "");
    try {
      final response = await http
          .post(Uri.parse(uri), body: body, headers: headers)
          .timeout(const Duration(seconds: 120), onTimeout: () {
        EasyLoading.dismiss();
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      responseJson = _returnResponse(response);
    } on SocketException {
      EasyLoading.dismiss();
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print(e);
    }
    return responseJson;
  }

  Future<dynamic> postMultipartData(
      String url, dynamic body, File _image, File _image1) async {
    var responseJson;
    try {
      ///[1] CREATING INSTANCE
      final dioRequest = Dio();
      var formData;
      formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(_image1.path,
            filename: basename(_image1.path)),
      });

      //[5] SEND TO SERVER
      final response = await dioRequest.post(
        '${APIBase.baseURL}$url',
        options: Options(contentType: 'multipart/form-data'),
        data: formData,
      );
      final result = json.decode(response.toString());

      responseJson = result;
    } on DioError catch (err) {
      print('ERROR  ${err.error}\n${err.response.data}');
    }

    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        {
          EasyLoading.dismiss();
          // ignore: noop_primitive_operations
          final responseJson = json.decode(response.body.toString());
          return responseJson;
        }
      case 400:
      case 403:
        {
          EasyLoading.dismiss();
          // ignore: noop_primitive_operations
          final responseJson = json.decode(response.body.toString());
          return responseJson;
          // throw BadRequestException(response.body.toString());
        }
      case 401:
        {
          EasyLoading.dismiss();
          // ignore: noop_primitive_operations
          throw UnauthorisedException(response.body.toString());
        }
      case 500:
      default:
        {
          EasyLoading.dismiss();
          throw FetchDataException(
              'Something went wrong with the server : ${response.statusCode}');
        }
    }
  }
}

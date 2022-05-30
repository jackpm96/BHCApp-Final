import 'dart:convert';

import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/network_module/api_base.dart';
import 'package:black_history_calender/network_module/api_path.dart';
import 'package:black_history_calender/screens/auth/model/stories_response.dart';
import 'package:black_history_calender/screens/auth/provider/auth_provider.dart';
import 'package:black_history_calender/screens/story/upload_media_response.dart';
import 'package:black_history_calender/widget/snackbar_widget.dart';
import 'package:black_history_calender/widget/text_field_border.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class StoryForm extends StatefulWidget {
  @override
  _StoryFormState createState() => _StoryFormState();
}

class _StoryFormState extends State<StoryForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  FocusNode _titleFocus = new FocusNode();
  FocusNode _descriptionFocus = new FocusNode();

  DateTime _datetime;
  File image;
  String token;
  String author;

  @override
  initState() {
    super.initState();
    initData();
  }

  initData() async {
    await Prefs.token.then((value) => setState(() {
          token = value;
        }));
    await Prefs.id.then((value) => setState(() {
          author = value;
        }));
  }

  _getFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile imagePick =
        await _picker.pickImage(source: ImageSource.gallery);
    if (imagePick == null) return;
    setState(() {
      final imageTemperory = File(imagePick.path);
      image = imageTemperory;
    });
  }

  addstory() async {
    UploadMediaResponse res = await uploadMedia(image, token);
    if (res != null) {
      print("Upload Media Api: ${res.id}");
      EasyLoading.show(dismissOnTap: false);
      try {
        final response =
            await Provider.of<AuthProvider>(context, listen: false).addStory(
          token,
          _titleController.text.trim(),
          _descriptionController.text.trim(),
          author,
          res.id,
        );

        if (response != null) {
          await Provider.of<AuthProvider>(context, listen: false)
              .updateStories(response as StoriesResponse);
          EasyLoading.dismiss();
          CommonWidgets.buildSnackbar(context, "Uploaded successful");
          Navigator.pop(context);
        } else {
          EasyLoading.dismiss();
          CommonWidgets.buildSnackbar(context, "Something went wrong");
        }
      } catch (e) {
        debugPrint("$e");
        EasyLoading.dismiss();
        CommonWidgets.buildSnackbar(context, "Server Down");
      }
    } else {
      EasyLoading.dismiss();
      CommonWidgets.buildSnackbar(context, "Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Add a new story"),
        // elevation: 0.0,
        // leading: GestureDetector(
        //     onTap: () async {
        //       Navigator.of(context).pop();
        //     },
        //     child: Image.asset(
        //       "assets/images/back.png",
        //       height: 25,
        //       width: 25,
        //       color: Colors.black,
        //     )),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  _getFromGallery();
                },
                child: Container(
                  height: 300,
                  width: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image:(true) ?DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(image)
                           ) : const DecorationImage(
                      fit: BoxFit.cover,
                      image:  AssetImage(
                          "assets/images/image_placeholder.jpeg")),
                  ),
                ),
              ),
              // Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Title",
                      style: GoogleFonts.montserrat(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 22),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldSideBorder(
                        tfieldController: _titleController,
                        focus: _titleFocus,
                        hint: "Title",
                        icon: null,
                        keyboardType: TextInputType.emailAddress),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Your Content",
                      style: GoogleFonts.montserrat(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 22),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      minLines: 2,
                      maxLines: 50,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        // focusedBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Color(0xffb1b1b1),
                        //     width: 1.0,
                        //   ),
                        // ),
                        // enabledBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Color(0xffb1b1b1),
                        //     width: 1.0,
                        //   ),
                        // ),
                        hintText: 'Enter A Message Here',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text(
                            'Publish Now',
                            style: GoogleFonts.montserrat(
                                color: Colors.grey, fontSize: 24),
                          ),
                          onPressed: () async {
                            await addstory();
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            primary: Colors.red.withOpacity(0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(2),
                                ),
                                side: BorderSide(color: white)),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<UploadMediaResponse> uploadMedia(File filePath, token) async {
    EasyLoading.show();
    var response;
    try {
      UploadMediaResponse uploadMediaResponse;
      String url = 'https://myblackhistorycalendar.com/wp-json/wp/v2/media';

      String fileName = filePath.path.split('/').last;

      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-Disposition': 'attachment; filename=$fileName',
        'Content-Type': 'image/*'
      };

      List<int> imageBytes = File(filePath.path).readAsBytesSync();
      var request = http.Request('POST', Uri.parse(url));
      request.headers.addAll(requestHeaders);
      request.bodyBytes = imageBytes;
      var res = await request.send();

      var convertedDataJson = await res.stream.bytesToString();
      response = jsonDecode(convertedDataJson);
    } catch (e) {
      debugPrint("$e");
      EasyLoading.dismiss();
      CommonWidgets.buildSnackbar(context, "Server Down");
      return null;
    }
    return UploadMediaResponse.fromJson(response as Map<String, dynamic>);
  }
}

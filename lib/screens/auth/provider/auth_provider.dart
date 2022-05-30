import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/network_module/api_response.dart';
import 'package:black_history_calender/screens/auth/model/account_details_response.dart';
import 'package:black_history_calender/screens/auth/model/addfavourite_response.dart';
import 'package:black_history_calender/screens/auth/model/addsetting_response.dart';
import 'package:black_history_calender/screens/auth/model/dob_response.dart';
import 'package:black_history_calender/screens/auth/model/img_response.dart';
import 'package:black_history_calender/screens/auth/model/fav_response.dart';
import 'package:black_history_calender/screens/auth/model/forgot_response.dart';
import 'package:black_history_calender/screens/auth/model/getcomment_response.dart';
import 'package:black_history_calender/screens/auth/model/getlike_response.dart';
import 'package:black_history_calender/screens/auth/model/login_response.dart';
import 'package:black_history_calender/screens/auth/model/newstories_response.dart';
import 'package:black_history_calender/screens/auth/model/postcomment_response.dart';
import 'package:black_history_calender/screens/auth/model/postlike_response.dart';
import 'package:black_history_calender/screens/auth/model/signup_response.dart';
import 'package:black_history_calender/screens/auth/model/stories_response.dart';
import 'package:black_history_calender/screens/auth/model/token_validate_response.dart';
import 'package:black_history_calender/screens/auth/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  AuthRepo _authRepo;

  ApiResponse<SignupResponse> _signup;
  ApiResponse<SignupResponse> get signup => _signup;

  ApiResponse<LoginResponse> _login;
  ApiResponse<LoginResponse> get login => _login;

  ApiResponse<ForgotResponse> _forgot;
  ApiResponse<ForgotResponse> get forgot => _forgot;

  List<StoriesResponse> _stories;
  List<StoriesResponse> get stories => _stories;

  ApiResponse<List<StoryData>> _newstories;
  ApiResponse<List<StoryData>> get newstories => _newstories;

  ApiResponse<FavResponse> _favStories;
  ApiResponse<FavResponse> get favStories => _favStories;

  ApiResponse<StoriesResponse> _addstory;
  ApiResponse<StoriesResponse> get addstory => _addstory;

  ApiResponse<AccountDetails> _details;
  ApiResponse<AccountDetails> get details => _details;

  LikesData _likesdata;
  LikesData get likesdata => _likesdata;

  ApiResponse<LikesData> _postlikedata;
  ApiResponse<LikesData> get postlikedata => _postlikedata;

  List<StoryData> _searchdata;
  List<StoryData> get searchdata => _searchdata;

  List<GetCommentResponse> _commentsdata;
  List<GetCommentResponse> get commentsdata => _commentsdata;

  ApiResponse<PostCommentResponse> _postcomment;
  ApiResponse<PostCommentResponse> get postcomment => _postcomment;

  ApiResponse<AddSettingResponse> _addsetting;
  ApiResponse<AddSettingResponse> get addsetting => _addsetting;

  ApiResponse<AddFavouriteResponse> _savefavourite;
  ApiResponse<AddFavouriteResponse> get savefavourite => _savefavourite;

  ApiResponse<TokenValidateResponse> _tokenValidate;
  ApiResponse<TokenValidateResponse> get tokenValidate => _tokenValidate;

  List<LocalStoriesResponse> _allContinueStories;
  List<LocalStoriesResponse> get allContinueStories => _allContinueStories;

  ApiResponse<UpdateDobResponse> _updateDob;
  ApiResponse<UpdateDobResponse> get updateDob => _updateDob;


  ApiResponse<UpdateImgResponse> _updateImg;
  ApiResponse<UpdateImgResponse> get updateImg => _updateImg;

  http.Response _subs;
  http.Response get subs => _subs;

  AuthProvider() {
    _authRepo = AuthRepo();
  }

  updateStoriesFavStatus(int index) {
    _newstories.data[index].isFavourite =
        _newstories.data[index].isFavourite.contains("1") ? "0" : "1";
    notifyListeners();
  }

  updateFavStatus(int index) {
    _favStories.data.data.data[index].isFavourite =
        _favStories.data.data.data[index].isFavourite.contains("1") ? "0" : "1";
    notifyListeners();
  }

  Future<UpdateDobResponse> updateDobApi(
    String userID,
    String dob,
  ) async {
    _updateDob = ApiResponse.loading('loading... ');
    notifyListeners();
    try {
      UpdateDobResponse updateDob = await _authRepo.updateDobApi(userID, dob);
      _updateDob = ApiResponse.completed(updateDob);
      notifyListeners();
      EasyLoading.dismiss();
      return updateDob;
    } catch (e) {
      _updateDob = ApiResponse.error(e.toString());
      notifyListeners();
      EasyLoading.dismiss();
      return null;
    }
  }
  Future<UpdateImgResponse> updateImgApi(
      String userID,
      String img,
      ) async {
    _updateImg = ApiResponse.loading('loading... ');
    notifyListeners();
    try {
      UpdateImgResponse updateImg = await _authRepo.updateImgApi(userID, img);
      _updateImg = ApiResponse.completed(updateImg);
      notifyListeners();
      EasyLoading.dismiss();
      return updateImg;
    } catch (e) {
      _updateImg = ApiResponse.error(e.toString());
      notifyListeners();
      EasyLoading.dismiss();
      return null;
    }
  }

  Future<List<LocalStoriesResponse>> getAllContinueStories() async {
    await Prefs.readingStories.then((value) {
      if (value != null && value.isNotEmpty) {
        List<LocalStoriesResponse> res = LocalStoriesResponse.decode(value);
        _allContinueStories = res.reversed.toList();
        notifyListeners();
      } else {
        _allContinueStories = [];
        notifyListeners();
      }
    });
    return _allContinueStories;
  }

  deleteContinueStory(id) {
    _allContinueStories.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<TokenValidateResponse> checkTokenValidate(String token) async {
    _tokenValidate = ApiResponse.loading('loading... ');
    notifyListeners();
    try {
      TokenValidateResponse tokenValidate =
          await _authRepo.checkTokenValidate(token);
      _tokenValidate = ApiResponse.completed(tokenValidate);
      notifyListeners();
      EasyLoading.dismiss();
      return tokenValidate;
    } catch (e) {
      _tokenValidate = ApiResponse.error(e.toString());
      notifyListeners();
      EasyLoading.dismiss();
      return null;
    }
  }

  Future<http.Response> makeSubscription(
      String selectedPackage, userID, token) async {
    notifyListeners();
    try {
      http.Response subs = selectedPackage.contains("yearly")
          ? await _authRepo.makeMonthlySubscription(userID, token, "2")
          : await _authRepo.makeMonthlySubscription(userID, token, "1");
      _subs = subs;
      notifyListeners();
      EasyLoading.dismiss();

      return subs;
    } catch (e) {
      debugPrint("$e");
      notifyListeners();
      EasyLoading.dismiss();
      return null;
    }
  }

  Future<List<StoriesResponse>> getStores() async {
    // _stories = ApiResponse.loading('loading... ');
    notifyListeners();
    try {
      var stories = await _authRepo.getStores();
      _stories = stories;
      //_stories = ApiResponse.completed(stories);
      notifyListeners();
      EasyLoading.dismiss();
      return stories;
    } catch (e) {
      // _stories = ApiResponse.error(e.toString());
      notifyListeners();
      EasyLoading.dismiss();
      return null;
    }
  }

  Future<AccountDetails> getDetails() async {
    // _details = ApiResponse.loading('loading... ');
    notifyListeners();
    try {
      var details = await _authRepo.getDetails();
      //_details = details;
      _details = ApiResponse.completed(details);
      notifyListeners();
      EasyLoading.dismiss();
      return details;
    } catch (e) {
      _details = ApiResponse.error(e.toString());
      notifyListeners();
      EasyLoading.dismiss();
      return null;
    }
  }

  Future<LikesData> getLikes(var postid) async {
    // _likesdata = ApiResponse.loading('loading... ');
    // notifyListeners();
    try {
      var data = await _authRepo.getLikes(postid);
      //_likesdata = data;
      // _likesdata = ApiResponse.completed(data);
      _likesdata = data;

      notifyListeners();
      EasyLoading.dismiss();
      return data;
    } catch (e) {
      _likesdata = LikesData();
      // _likesdata = ApiResponse.error(e.toString());
      notifyListeners();
      EasyLoading.dismiss();
      return null;
    }
  }

  Future postlike(var postid, var value) async {
    // _likesdata = ApiResponse.loading('loading... ');
    // notifyListeners();
    try {
      LikesData postlikedata = await _authRepo.postlike(postid, value);
      // _likesdata = ApiResponse.completed(postlikedata);
      _likesdata = postlikedata;
      notifyListeners();
      EasyLoading.dismiss();
      // return postlikedata;
    } catch (e) {
      _likesdata = LikesData();
      // _likesdata = ApiResponse.error(e.toString());
      notifyListeners();
      EasyLoading.dismiss();
      // return null;
    }
  }

  updateStories(StoriesResponse story) {
    _stories.add(story);
    notifyListeners();
  }

  Future<ForgotResponse> resetPassword(
      String email, String password, String passcode) async {
    _forgot = ApiResponse.loading('loading... ');
    notifyListeners();
    try {
      ForgotResponse forgot =
          await _authRepo.resetPassword(email, password, passcode);
      _forgot = ApiResponse.completed(forgot);
      notifyListeners();
      EasyLoading.dismiss();
      return forgot;
    } catch (e) {
      _forgot = ApiResponse.error(e.toString());
      notifyListeners();
      EasyLoading.dismiss();
      return null;
    }
  }

  Future<ForgotResponse> forgotPassword(String email) async {
    _forgot = ApiResponse.loading('loading... ');
    notifyListeners();
    try {
      ForgotResponse forgot = await _authRepo.forgotPassword(email);
      _forgot = ApiResponse.completed(forgot);
      notifyListeners();
      EasyLoading.dismiss();
      return forgot;
    } catch (e) {
      _forgot = ApiResponse.error(e.toString());
      notifyListeners();
      EasyLoading.dismiss();
      return null;
    }
  }

  Future<LoginResponse> loginUser(
      String userName, String password, String token) async {
    _login = ApiResponse.loading('loading... ');
    notifyListeners();
    try {
      LoginResponse login =
          await _authRepo.loginUser(userName, password, token);
      _login = ApiResponse.completed(login);
      notifyListeners();
      EasyLoading.dismiss();
      return login;
    } catch (e) {
      _login = ApiResponse.error(e.toString());
      notifyListeners();
      EasyLoading.dismiss();
      return null;
    }
  }

  Future<SignupResponse> signupUser(String userName, String email,
      String password, String name, String firstName, String lastName) async {
    _signup = ApiResponse.loading('loading... ');
    notifyListeners();
    try {
      SignupResponse signup = await _authRepo.signupUser(
          userName, email, password, name, firstName, lastName);
      _signup = ApiResponse.completed(signup);
      notifyListeners();
      EasyLoading.dismiss();
      return signup;
    } catch (e) {
      _signup = ApiResponse.error(e.toString());
      notifyListeners();
      EasyLoading.dismiss();
      return null;
    }
  }

  Future<dynamic> addStory(String token, String title, String content,
      String author, dynamic image) async {
    _addstory = ApiResponse.loading('loading... ');
    notifyListeners();
    try {
      StoriesResponse addstory =
          await _authRepo.addStory(token, title, content, author, image);
      _addstory = ApiResponse.completed(addstory);
      notifyListeners();
      EasyLoading.dismiss();
      return addstory;
    } catch (e) {
      _addstory = ApiResponse.error(e.toString());
      notifyListeners();
      EasyLoading.dismiss();
      return null;
    }
  }

  Future<List<StoryData>> calendarsearch(
      String from, String until, currentpage) async {
    //_searchdata = ApiResponse.loading('loading... ');
    notifyListeners();
    try {
      var searchdata = await _authRepo.calendarsearch(from, until, currentpage);
      _searchdata = searchdata;
      //_searchdata = ApiResponse.completed(data);
      notifyListeners();
      EasyLoading.dismiss();
      return searchdata;
    } catch (e) {
      print(e);
      //_searchdata = ApiResponse.error(e.toString());
      notifyListeners();
      EasyLoading.dismiss();
      return null;
    }
  }

  Future<List<GetCommentResponse>> getcomments(var postid) async {
    //_commentsdata = ApiResponse.loading('loading... ');
    notifyListeners();
    try {
      var data = await _authRepo.getcomments(postid);
      _commentsdata = data;
      //_commentsdata = ApiResponse.completed(data);
      notifyListeners();
      data[0].date.weekday;
      EasyLoading.dismiss();
      return data;
    } catch (e) {
      //_commentsdata = ApiResponse.error(e.toString());
      notifyListeners();
      EasyLoading.dismiss();
      return null;
    }
  }

  Future<PostCommentResponse> postcomments(var postid, var comment) async {
    _postcomment = ApiResponse.loading('loading... ');
    notifyListeners();
    try {
      var data = await _authRepo.postcomments(postid, comment);
      _postcomment = ApiResponse.completed(data);
      notifyListeners();
      EasyLoading.dismiss();
      return data;
    } catch (e) {
      _postcomment = ApiResponse.error(e.toString());
      notifyListeners();
      EasyLoading.dismiss();
      return null;
    }
  }

  Future<AddSettingResponse> SettingInfo(
      var noti_status, var email_status) async {
    _addsetting = ApiResponse.loading('loading... ');
    notifyListeners();
    try {
      var data = await _authRepo.SettingInfo(noti_status, email_status);
      _addsetting = ApiResponse.completed(data);
      notifyListeners();
      EasyLoading.dismiss();
      return data;
    } catch (e) {
      _addsetting = ApiResponse.error(e.toString());
      notifyListeners();
      EasyLoading.dismiss();
      return null;
    }
  }

  Future<void> getourstories() async {
    _newstories = ApiResponse.loading('loading... ');
    notifyListeners();
    try {
      List<StoryData> stories = await _authRepo.getourstories();
      _newstories = ApiResponse.completed(stories);
      notifyListeners();
      EasyLoading.dismiss();
    } catch (e) {
      _newstories = ApiResponse.error(e.toString());
      notifyListeners();
      EasyLoading.dismiss();
    }
  }

  Future<void> getFavStories() async {
    _favStories = ApiResponse.loading('loading... ');
    notifyListeners();
    try {
      FavResponse favStories = await _authRepo.getFavStories();
      _favStories = ApiResponse.completed(favStories);
      notifyListeners();
      EasyLoading.dismiss();
    } catch (e) {
      _favStories = ApiResponse.error(e.toString());
      notifyListeners();
      EasyLoading.dismiss();
    }
  }

  Future<List<StoryData>> loadmoredata(currentpage) async {
    //_newstories = ApiResponse.loading('loading... ');
    notifyListeners();
    try {
      var stories = await _authRepo.loadmoredata(currentpage);
      // _newstories = stories;
      // _newstories = stories;
      //_stories = ApiResponse.completed(stories);
      notifyListeners();
      EasyLoading.dismiss();

      return stories;
    } catch (e) {
      //_newstories = ApiResponse.error(e.toString());
      notifyListeners();
      EasyLoading.dismiss();
      return null;
    }
  }

  Future<AddFavouriteResponse> addfavourite(var postid, var value) async {
    _savefavourite = ApiResponse.loading('loading... ');
    notifyListeners();
    try {
      var data = await _authRepo.addfavourite(postid, value);
      _savefavourite = ApiResponse.completed(data);
      notifyListeners();
      EasyLoading.dismiss();
      return data;
    } catch (e) {
      _savefavourite = ApiResponse.error(e.toString());
      notifyListeners();
      EasyLoading.dismiss();
      return null;
    }
  }
}

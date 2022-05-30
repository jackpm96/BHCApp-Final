import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

//import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FacebookResponse {
  User user;
  FacebookLoginResult response;

  FacebookResponse(this.user, this.response);
}

class GoogleResponse {
  User user;
  GoogleSignInAuthentication response;

  GoogleResponse(this.user, this.response);
}

abstract class AuthBase {
  User get currentUser;

  Stream<User> authStateChanges();

  Future<GoogleResponse> signInWithGoogle();

  Future<FacebookResponse> signInWithFacebook();

  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User get currentUser => _firebaseAuth.currentUser;

  @override
  Future<GoogleResponse> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      // if (googleAuth.idToken != null) {
      final userCredential = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken));
      return GoogleResponse(userCredential.user, googleAuth);
    } else {
      throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID Token');
    }
    // } else {
    //   throw FirebaseAuthException(
    //       message: 'Sign in aborted by User', code: 'ERROR_ABORTED_BY_USER');
    // }
  }

  @override
  Future<FacebookResponse> signInWithFacebook() async {
    final fb = FacebookLogin(debug: true);
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
      // FacebookPermission.pagesShowList,
      FacebookPermission.userFriends
    ]);
    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken;
        print(response.accessToken.userId);
        final userCredential = await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.credential(accessToken.token),
        );
        return FacebookResponse(userCredential.user, response);
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: response.error.developerMessage,
        );
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<void> signOut() async {
    await GoogleSignIn().isSignedIn()
        ? await GoogleSignIn().signOut()
        : await FacebookLogin().isLoggedIn
            ? await FacebookLogin().logOut()
            : await _firebaseAuth.signOut();
    // final googleSignIn = GoogleSignIn();
    // await googleSignIn.signOut();
    // final facebookLogin = FacebookLogin();
    // await facebookLogin.logOut();
    // await _firebaseAuth.signOut();
  }
}

/**
 *
 * import 'package:firebase_auth/firebase_auth.dart';
    import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
    import 'package:flutter_login_facebook/flutter_login_facebook.dart';
    //import 'package:flutter_login_facebook/flutter_login_facebook.dart';
    import 'package:google_sign_in/google_sign_in.dart';
    import 'package:firebase_auth/firebase_auth.dart';

    class FacebookResponse {
    User user;
    LoginResult response;

    FacebookResponse(this.user, this.response);
    }

    class GoogleResponse {
    User user;
    GoogleSignInAuthentication response;

    GoogleResponse(this.user, this.response);
    }

    abstract class AuthBase {
    User get currentUser;

    Stream<User> authStateChanges();

    Future<GoogleResponse> signInWithGoogle();

    Future<FacebookResponse> signInWithFacebook();

    Future<void> signOut();
    }

    class Auth implements AuthBase {
    final _firebaseAuth = FirebaseAuth.instance;

    @override
    Stream<User> authStateChanges() => _firebaseAuth.authStateChanges();

    @override
    User get currentUser => _firebaseAuth.currentUser;

    @override
    Future<GoogleResponse> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
    final googleAuth = await googleUser.authentication;
    if (googleAuth.idToken != null) {
    final userCredential = await _firebaseAuth.signInWithCredential(
    GoogleAuthProvider.credential(
    idToken: googleAuth.idToken,
    accessToken: googleAuth.accessToken));
    return GoogleResponse(userCredential.user, googleAuth);
    } else {
    throw FirebaseAuthException(
    code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
    message: 'Missing Google ID Token');
    }
    } else {
    throw FirebaseAuthException(
    message: 'Sign in aborted by User', code: 'ERROR_ABORTED_BY_USER');
    }
    }

    @override
    Future<FacebookResponse> signInWithFacebook() async {
    final LoginResult response = await FacebookAuth.instance.login();
    // final fb = FacebookLogin(debug: true);
    // final response = await fb.logIn(permissions: [
    //   FacebookPermission.publicProfile,
    //   FacebookPermission.email,
    //   FacebookPermission.userBirthday
    // ]);
    switch (response.status) {
    case LoginStatus.success:
    final accessToken = response.accessToken;
    print(response.accessToken.userId);
    final userCredential = await _firebaseAuth.signInWithCredential(
    FacebookAuthProvider.credential(accessToken.token),
    );
    final userData = await FacebookAuth.i.getUserData(
    fields: "name,email,picture.width(200),birthday,friends,gender,link",
    );
    print(userData);
    return FacebookResponse(userCredential.user, response);
    case LoginStatus.cancelled:
    throw FirebaseAuthException(
    code: 'ERROR_ABORTED_BY_USER',
    message: 'Sign in aborted by user',
    );
    case LoginStatus.failed:
    throw FirebaseAuthException(
    code: 'ERROR_FACEBOOK_LOGIN_FAILED',
    message: response.message,
    );
    default:
    throw UnimplementedError();
    }
    }

    @override
    Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    await _firebaseAuth.signOut();
    }
    }

 *
 * **/

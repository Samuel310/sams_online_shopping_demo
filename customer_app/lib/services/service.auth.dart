import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:oyil_boutique/services/service.cart.dart';
import 'package:oyil_boutique/services/service.fcm.dart';
import 'package:oyil_boutique/services/service.wishlist.dart';
import 'package:http/http.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // auth change user stream
  Stream<User> get user {
    return _auth.userChanges();
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // todo load cart and wishlist here..
      if (_auth.currentUser.uid != null) {
        await createAndUploadDeviceID(_auth.currentUser.uid);
        await WishlistDatabaseService().getAllProductsInWishlist(_auth.currentUser.uid);
        await CartDatabaseService().getAllProductsInCart(_auth.currentUser.uid);
      }
    } catch (error) {
      print(error);
      return error.message;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String name, String email, String password, {String profileUrl}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
      // userUpdateInfo.displayName = name;
      // await result.user.updateProfile(userUpdateInfo);
      // return refreshUserData();
      if (profileUrl != null) {
        await _auth.currentUser.updateProfile(displayName: name, photoURL: profileUrl);
      } else {
        await _auth.currentUser.updateProfile(displayName: name);
      }
      //  load cart and wishlist here..
      // await WishlistDatabaseService()
      //     .getAllProductsInWishlist(_auth.currentUser.uid);
      // await CartDatabaseService().getAllProductsInCart(_auth.currentUser.uid);
    } catch (error) {
      print(error.toString());
      return error.message;
    }
  }

  // Future<FirebaseUser> refreshUserData() async{
  //   FirebaseUser user = await _auth.currentUser();
  //   await user.reload();
  //   return _auth.currentUser();
  // }

  // sign out
  Future signOut() async {
    try {
      FacebookLogin fb = FacebookLogin();
      bool isUserLoggedIn = await fb.isLoggedIn;
      if (isUserLoggedIn) {
        await fb.logOut();
      }
      await _auth.signOut();
      // todo clear cart and wishlist here..
      //globalWishList.clear();
      if (globalCartList.isNotEmpty) {
        globalCartList.clear();
      }
      if (globalWishList.isNotEmpty) {
        globalWishList.clear();
      }
    } catch (error) {
      print(error.toString());
      return error.message;
    }
  }

  // sign out
  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (error) {
      print(error.toString());
      return error.message;
    }
  }

  // Future deteteAccount() async {
  //   try {
  //     FirebaseUser user = await _auth.currentUser();
  //     await DatabaseService(uid: user.uid).deleteAllData();
  //     await user.delete();
  //   } catch (error) {
  //     print(error.toString());
  //   }
  // }

  Future sendEmailVerificationLink(User user) async {
    try {
      print("XXXXXXXXXX sendEmailVerificationLink");
      await user.sendEmailVerification();
      return 'success';
    } catch (e) {
      print(e.toString());
      return e.message;
    }
  }

  Future<Response> loginUsingFacebook() async {
    try {
      final facebookLogin = FacebookLogin();
      facebookLogin.loginBehavior = FacebookLoginBehavior.nativeOnly;
      final result = await facebookLogin.logIn(['email']);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          // OAuthCredential credential =
          //     FacebookAuthProvider.credential(result.accessToken.token);
          Response graphResponse = await get(Uri.parse('https://graph.facebook.com/v2.12/me?fields=name,email,picture.width(800).height(800)&access_token=${result.accessToken.token}'));
          //await _auth.signInWithCredential(credential);
          // await _auth.currentUser.updateProfile(
          //     photoURL: json.decode(graphResponse.body)['picture']['data']
          //         ['url']);
          // // todo load cart and wishlist here..
          // await WishlistDatabaseService()
          //     .getAllProductsInWishlist(_auth.currentUser.uid);
          // await CartDatabaseService()
          //     .getAllProductsInCart(_auth.currentUser.uid);
          return graphResponse;
          break;
        case FacebookLoginStatus.cancelledByUser:
          print('login process canceled by user.');
          return null;
          break;
        case FacebookLoginStatus.error:
          print('Error occured while loging in.');
          print(result.errorMessage);
          return null;
          break;
        default:
          print('Executed default');
          return null;
          break;
      }
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updateProfile(String userid, File profileImage, String displayname) async {
    String url;
    if (profileImage != null) {
      try {
        await FirebaseStorage.instance.ref().child('userprofiles').child(userid).delete();
      } catch (e) {
        print("XXXXXX updateProfile 2 Xxxxxxxxxxxxx");
        print(e);
      }

      try {
        TaskSnapshot sts = await FirebaseStorage.instance.ref().child('userprofiles').child(userid).putFile(profileImage);
        url = await sts.ref.getDownloadURL();
      } catch (e) {
        print("XXXXXX updateProfile 3 Xxxxxxxxxxxxx");
        print(e);
      }
    }

    if (url != null) {
      await _auth.currentUser.updateProfile(displayName: displayname, photoURL: url);
    } else {
      await _auth.currentUser.updateProfile(displayName: displayname);
    }
  }
}

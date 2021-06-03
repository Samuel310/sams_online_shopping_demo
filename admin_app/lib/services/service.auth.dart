import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:obs_admin/services/service.fcm.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User> get user {
    return _auth.userChanges();
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> ds = await FirebaseFirestore.instance.collection("users").doc("obsadmin").get();

      if (ds.data()['email'] != null && ds.data()['email'] == email) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        if (_auth.currentUser.uid != null) {
          await createAndUploadDeviceID('obsadmin');
        }
      } else {
        return "Unauthorized Access, Login Failed";
      }
    } catch (error) {
      print(error);
      return error.message;
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return error.message;
    }
  }

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (error) {
      print(error.toString());
      return error.message;
    }
  }
}

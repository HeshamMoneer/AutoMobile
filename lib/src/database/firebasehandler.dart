import 'package:AutoMobile/src/repository/errorhandler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireBaseHandler {
  FireBaseHandler();

  Future<void> init() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      ErrorHandler(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getAll(String collectionName) async {
    try {
      var receivedData =
          (await FirebaseFirestore.instance.collection(collectionName).get())
              .docs;
      List<Map<String, dynamic>> result = receivedData.map((el) {
        return el.data();
      }).toList();
      return result;
    } catch (e) {
      ErrorHandler(e.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>> getById(
      String collectionName, String documentId) async {
    try {
      var receivedData = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentId)
          .get();
      if (receivedData.exists) {
        return receivedData.data() ?? {};
      } else {
        ErrorHandler("$documentId does not exist in the DB");
        return {};
      }
    } catch (e) {
      ErrorHandler(e.toString());
      return {};
    }
  }

  Future<String> post(String collectionName, Map<String, dynamic> body) async {
    //Equivalent to put functionality in essence
    try {
      var receivedData =
          await FirebaseFirestore.instance.collection(collectionName).add(body);
      return receivedData.id;
    } catch (e) {
      ErrorHandler(e.toString());
      return "";
    }
  }

  Future<void> delete(String collectionName, String documentId) async {
    //TODO: documentation says that this method won't delete the document subcollections
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentId)
          .delete();
    } catch (e) {
      ErrorHandler(e.toString());
    }
  }

  Future<void> patch(String collectionName, String documentId,
      Map<String, dynamic> body) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentId)
          .update(body);
    } catch (e) {
      ErrorHandler(e.toString());
    }
  }

  Future<void> signup(String email, String password, String username) async {
    try {
      //This will need to be extended to include user general info
      var authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({'email': email});
    } catch (e) {
      ErrorHandler(e.toString());
    }
  }

  Future<String> login(String email, String password) async {
    try {
      var authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return authResult.user!.uid;
    } catch (e) {
      ErrorHandler(e.toString());
      return '';
    }
  }

  Future<void> signout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ErrorHandler(e.toString());
    }
  }
}

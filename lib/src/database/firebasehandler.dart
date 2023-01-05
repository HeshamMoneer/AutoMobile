import 'dart:io';

import 'package:AutoMobile/src/repository/errorhandler.dart';
import 'package:AutoMobile/src/widgets/chat_body.dart';
import 'package:AutoMobile/src/widgets/inbox_body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:AutoMobile/src/models/user.dart' as ourUser;
import 'package:firebase_messaging/firebase_messaging.dart';

class FireBaseHandler {
  String getCurrentUserId() {
    if (FirebaseAuth.instance.currentUser == null) return "";
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<List<Map<String, dynamic>>> getAll(String collectionName) async {
    try {
      var receivedData =
          (await FirebaseFirestore.instance.collection(collectionName).get())
              .docs;
      List<Map<String, dynamic>> result = receivedData.map((el) {
        Map<String, dynamic> result = el.data();
        result["id"] = el.reference.id;
        return result;
      }).toList();
      return result;
    } catch (e) {
      ErrorHandler(e.toString());
      rethrow;
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
        var returned = receivedData.data() ?? {};
        returned["id"] = receivedData.reference.id;
        return returned;
      } else {
        ErrorHandler("$documentId does not exist in the DB");
        throw Exception("$documentId does not exist in the DB");
      }
    } catch (e) {
      ErrorHandler(e.toString());
      rethrow;
    }
  }

  Future<String> post(String collectionName, Map<String, dynamic> body) async {
    //Equivalent to put functionality in essence
    try {
      if (collectionName == "user") {
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(getCurrentUserId())
            .set(body);
        return getCurrentUserId();
      }
      var receivedData =
          await FirebaseFirestore.instance.collection(collectionName).add(body);
      return receivedData.id;
    } catch (e) {
      ErrorHandler(e.toString());
      rethrow;
    }
  }

  Future<void> delete(String collectionName, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentId)
          .delete();
    } catch (e) {
      ErrorHandler(e.toString());
      rethrow;
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
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      var fbm = FirebaseMessaging.instance;
      String userId = getCurrentUserId();
      fbm.subscribeToTopic(userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> login(String email, String password) async {
    try {
      var authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      var fbm = FirebaseMessaging.instance;
      String userId = authResult.user!.uid;
      fbm.subscribeToTopic(userId);
      return userId;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signout() async {
    try {
      String userId = getCurrentUserId();
      await FirebaseAuth.instance.signOut();
      var fbm = FirebaseMessaging.instance;
      fbm.unsubscribeFromTopic(userId);
    } catch (e) {
      ErrorHandler(e.toString());
      rethrow;
    }
  }

  StreamBuilder<QuerySnapshot> customStreamBuilder(
      Widget function(List<QueryDocumentSnapshot<Object?>> documents),
      String collectionName,
      String orderBy,
      bool descending) {
    var myStream = FirebaseFirestore.instance
        .collection(collectionName)
        .orderBy(orderBy, descending: descending)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: myStream,
        builder: (ctx, strSnapshot) {
          if (strSnapshot.hasData) {
            var documents = strSnapshot.data!.docs;
            //The function uses the retrieved documents to build a widget
            return function(documents);
          } else if (strSnapshot.hasError) {
            return ErrorWidget(strSnapshot.error.toString());
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  StreamBuilder<QuerySnapshot> chatStreamBuilder() {
    var myStream = FirebaseFirestore.instance
        .collection("message")
        .where("users", arrayContains: getCurrentUserId())
        .orderBy("sentDate", descending: true)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: myStream,
        builder: (ctx, strSnapshot) {
          if (strSnapshot.hasData) {
            return InboxBody(
              msgsSnapshot: strSnapshot,
            );
          } else if (strSnapshot.hasError) {
            return ErrorWidget(strSnapshot.error.toString());
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  StreamBuilder<QuerySnapshot> singleChatStreamBuilder(ourUser.User otherUser) {
    var myStream = FirebaseFirestore.instance
        .collection("message")
        .where("users", whereIn: [
          [getCurrentUserId(), otherUser.id],
          [otherUser.id, getCurrentUserId()]
        ])
        .orderBy("sentDate", descending: true)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: myStream,
        builder: (ctx, strSnapshot) {
          if (strSnapshot.hasData) {
            return ChatBody(
              strSnapshot: strSnapshot,
            );
          } else if (strSnapshot.hasError) {
            return ErrorWidget(strSnapshot.error.toString());
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<String> uploadImage(String userId, File file) async {
    // random hash
    String filename = Uuid().v4();
    var snapshot = await FirebaseStorage.instance
        .ref()
        .child('images/$userId/$filename')
        .putFile(file);
    return snapshot.ref.getDownloadURL();
  }

  Future<String> uploadProfilePic(String userId, File file) async {
    var snapshot =
        await FirebaseStorage.instance.ref().child('$userId').putFile(file);
    return snapshot.ref.getDownloadURL();
  }
}

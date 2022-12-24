import 'dart:collection';

import 'package:AutoMobile/src/models/chat.dart';
import 'package:AutoMobile/src/models/message.dart';
import 'package:AutoMobile/src/widgets/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';

class InboxBody extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> msgsSnapshot;
  InboxBody({required this.msgsSnapshot});

  List<Chat> messagesDocsToChats(
      List<QueryDocumentSnapshot> allMessages, String currentUserId) {
    List<Chat> result = [];
    HashSet<String> finishedUsers = HashSet<String>();
    for (QueryDocumentSnapshot message in allMessages) {
      Map<String, dynamic> messageMap = message.data() as Map<String, dynamic>;
      String otherUserId =
          messageMap["users"].where((e) => e != currentUserId).toList()[0];
      if (!finishedUsers.contains(otherUserId)) {
        finishedUsers.add(otherUserId);
        result.add(Chat(
            from_userId: messageMap["users"][0],
            to_userId: messageMap["users"][1],
            lastMessage: Message(
                content: messageMap["content"],
                seen: messageMap["seen"],
                senderId: messageMap["users"][0],
                sentDate: messageMap["sentDate"].toDate())));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var allProvider = Provider.of<AllProvider>(context, listen: false);
    var allMessages = msgsSnapshot.data!.docs;
    List<Chat> chatsList = messagesDocsToChats(
        allMessages, allProvider.repository.fireBaseHandler.getCurrentUserId());

    return ListView.builder(
      itemBuilder: ((ctx, index) {
        Chat curChat = chatsList[index];
        return ChatUser(curChat: curChat);
      }),
      itemCount: chatsList.length,
    );
  }
}

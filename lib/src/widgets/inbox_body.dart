import 'package:AutoMobile/src/models/chat.dart';
import 'package:AutoMobile/src/models/message.dart';
import 'package:AutoMobile/src/widgets/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InboxBody extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> strSnapshot;
  InboxBody({required this.strSnapshot});

  @override
  Widget build(BuildContext context) {
    var chatsList = strSnapshot.data!.docs;
    return ListView.builder(
      itemBuilder: ((ctx, index) {
        var curChatMap = chatsList[index].data() as Map;
        Chat curChat = Chat(
            user1Id: curChatMap["users"][0],
            user2Id: curChatMap["users"][1],
            id: chatsList[index].reference.id,
            messages: curChatMap["messages"].map<Message>((message) {
              return Message(
                  content: message["content"],
                  sentDate: message["sentDate"].toDate(),
                  seen: message["seen"],
                  senderId: message["senderId"]);
            }).toList());
        return ChatUser(curChat: curChat);
      }),
      itemCount: chatsList.length,
    );
  }
}

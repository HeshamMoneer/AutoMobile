import 'package:AutoMobile/src/models/message.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat_message.dart';

class ChatBody extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> strSnapshot;
  ChatBody({required this.strSnapshot});

  @override
  Widget build(BuildContext context) {
    var messagesList = strSnapshot.data!.docs;
    return ListView.builder(
      itemBuilder: ((ctx, index) {
        var curMessageMap = messagesList[index].data() as Map<String, dynamic>;
        Message curMessage = Message(
            content: curMessageMap["content"],
            sentDate: curMessageMap["sentDate"].toDate(),
            seen: curMessageMap["seen"],
            senderId: curMessageMap["users"][0]);
        return ChatMessage(curMessage: curMessage);
      }),
      itemCount: messagesList.length,
      reverse: true,
    );
  }
}

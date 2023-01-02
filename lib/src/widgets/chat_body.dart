import 'package:AutoMobile/src/models/message.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';
import 'chat_message.dart';

class ChatBody extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> strSnapshot;
  ChatBody({required this.strSnapshot});

  Widget seenWidget(bool isSeen) {
    String str = isSeen ? "seen" : "not seen yet";
    return Padding(
      child: Text(
        str,
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
      padding: EdgeInsets.all(5),
    );
  }

  @override
  Widget build(BuildContext context) {
    var allProvider = Provider.of<AllProvider>(context, listen: false);
    String curUserId = allProvider.getCurrentUserId();
    var messagesList = strSnapshot.data!.docs;
    bool noMessages = messagesList.length == 0;
    var lastMessageMap =
        noMessages ? {} : (messagesList[0].data() as Map<String, dynamic>);
    Message? lastMessage = noMessages
        ? null
        : Message(
            id: messagesList.length == 0 ? "" : messagesList[0].reference.id,
            content: lastMessageMap["content"],
            sentDate: lastMessageMap["sentDate"].toDate(),
            seen: lastMessageMap["seen"],
            senderId: lastMessageMap["users"][0]);
    bool isLastMessageMine = !noMessages && lastMessage!.senderId == curUserId;
    bool isLastMessageSeen = !noMessages && lastMessage!.seen;
    if (!noMessages && !isLastMessageMine && !isLastMessageSeen) {
      allProvider.markAsSeen(lastMessage!.id);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: ((ctx, index) {
              var curMessageMap =
                  messagesList[index].data() as Map<String, dynamic>;
              Message curMessage = Message(
                  id: messagesList[index].reference.id,
                  content: curMessageMap["content"],
                  sentDate: curMessageMap["sentDate"].toDate(),
                  seen: curMessageMap["seen"],
                  senderId: curMessageMap["users"][0]);
              return ChatMessage(curMessage: curMessage);
            }),
            itemCount: messagesList.length,
            reverse: true,
          ),
        ),
        if (isLastMessageMine) seenWidget(isLastMessageSeen),
      ],
    );
  }
}

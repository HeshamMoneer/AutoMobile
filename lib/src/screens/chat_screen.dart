import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../provider/provider.dart';

class ChatScreen extends StatelessWidget {
  final messageController = TextEditingController();

  void sendMessage(AllProvider allProvider, String to_userId) async {
    allProvider.sendMessage(messageController.text, to_userId);
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    User otherUser = ModalRoute.of(context)!.settings.arguments as User;
    var allProvider = Provider.of<AllProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Inbox"),
      ),
      body: Column(children: [
        Expanded(
            child: allProvider.repository.fireBaseHandler
                .singleChatStreamBuilder(otherUser)),
        Container(
          color: Colors.blueGrey,
          padding: EdgeInsets.all(5),
          child: Row(children: [
            Expanded(
                child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintText: "Enter your message",
                  hintStyle: TextStyle(color: Colors.white)),
              controller: messageController,
            )),
            ElevatedButton(
                onPressed: () {
                  sendMessage(allProvider, otherUser.id);
                },
                child: Text("Send"))
          ]),
        )
      ]),
    );
  }
}

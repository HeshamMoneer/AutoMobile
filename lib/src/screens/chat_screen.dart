import 'package:AutoMobile/src/themes/theme_color.dart';
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
        title: Text("${otherUser.firstName} ${otherUser.lastName}"),
      ),
      body: Column(children: [
        Expanded(
            child: allProvider.repository.fireBaseHandler
                .singleChatStreamBuilder(otherUser)),
        Container(
          color: ThemeColor.lightblack,
          padding: EdgeInsets.all(5),
          child: Row(children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Enter your message",
                    hintStyle: TextStyle(
                        color: Colors.white, fontStyle: FontStyle.italic)),
                controller: messageController,
              ),
            )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: ThemeColor.grey),
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

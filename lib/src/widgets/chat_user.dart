import 'package:AutoMobile/src/widgets/chat_user_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chat.dart';
import '../models/user.dart';
import '../provider/provider.dart';

class ChatUser extends StatelessWidget {
  final Chat curChat;
  ChatUser({required this.curChat});

  @override
  Widget build(BuildContext context) {
    var allProvider = Provider.of<AllProvider>(context, listen: false);
    String curUserId = allProvider.getCurrentUserId();
    String otherUserId = curChat.from_userId == curUserId
        ? curChat.to_userId
        : curChat.from_userId;

    String truncateMessageContent(String str, int cutoff) {
      return (str.length <= cutoff) ? str : '${str.substring(0, cutoff)}...';
    }

    Future<User> otherUser = allProvider.getUserById(otherUserId);
    return FutureBuilder<User>(
      future: otherUser,
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          String username =
              snapshot.data!.firstName + " " + snapshot.data!.lastName;
          var userImage = Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(snapshot.data!.profilePicPath),
              radius: 40,
              backgroundColor: Colors.transparent,
            ),
          );
          String lastMessage = curChat.lastMessage.content;
          if (curChat.lastMessage.senderId == curUserId)
            lastMessage = 'You: $lastMessage';
          return InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed('/inbox/chat', arguments: snapshot.data),
              child: Padding(
                padding: EdgeInsets.all(7),
                child: Row(children: [
                  userImage,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        truncateMessageContent(lastMessage, 30),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )
                ]),
              ));
        } else if (snapshot.hasError) {
          return ErrorWidget(
              "The other user data could not be found!! + ${snapshot.error}");
        } else {
          return ChatUserSkeleton();
        }
      },
    );
  }
}

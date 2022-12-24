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
    Future<User> otherUser = allProvider.getUserById(otherUserId);
    return FutureBuilder<User>(
      future: otherUser,
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          String username =
              snapshot.data!.firstName + " " + snapshot.data!.lastName;
          var userImage = CircleAvatar(
            backgroundImage: NetworkImage(snapshot.data!.profilePicPath),
            radius: 120,
            backgroundColor: Colors.transparent,
          );
          String lastMessage = curChat.lastMessage.content;
          return InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed('/inbox/chat', arguments: snapshot.data),
              child: Row(children: [
                userImage,
                Column(
                  children: [
                    Text(username),
                    Text(lastMessage),
                  ],
                )
              ]));
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

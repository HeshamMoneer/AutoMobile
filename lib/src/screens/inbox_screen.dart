import 'package:AutoMobile/src/screens/search_users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../provider/provider.dart';
import '../themes/theme.dart';
import '../themes/theme_color.dart';

class InboxScreen extends StatelessWidget {
  AppBar appBar(context, allUsers) {
    return AppBar(
      title: Text("Inbox",
          style: AppTheme
              .titleStyle2), //TextStyle(color: ThemeColor.titleTextColor)),
      actions: [
        IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchUsers(allUsers));
            },
            icon: Icon(Icons.chat_bubble_outline_outlined))
      ],
      backgroundColor: ThemeColor.lightblack,
    );
  }

  @override
  Widget build(BuildContext context) {
    var allProvider = Provider.of<AllProvider>(context, listen: false);
    String myId = allProvider.getCurrentUserId();
    Future<List<User>> allUsers = allProvider.getAllUsersAsList();
    return FutureBuilder(
        future: allUsers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: appBar(
                  context,
                  snapshot.data?.where(((element) {
                    return element.id != myId;
                  })).toList()),
              body: allProvider.repository.fireBaseHandler.chatStreamBuilder(),
            );
          } else if (snapshot.hasError) {
            return ErrorWidget(snapshot.error.toString());
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

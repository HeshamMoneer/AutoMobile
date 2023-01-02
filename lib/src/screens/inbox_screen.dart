import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';
import '../themes/theme.dart';
import '../themes/theme_color.dart';

class InboxScreen extends StatelessWidget {
  final appBar = AppBar(
    title: Text("Inbox",
        style: AppTheme
            .titleStyle2), //TextStyle(color: ThemeColor.titleTextColor)),
    actions: [
      IconButton(
          onPressed: () {}, icon: Icon(Icons.chat_bubble_outline_outlined))
    ],
    backgroundColor: ThemeColor.lightblack,
//
  );
  @override
  Widget build(BuildContext context) {
    var allProvider = Provider.of<AllProvider>(context, listen: false);
    return Scaffold(
      appBar: appBar,
      body: allProvider.repository.fireBaseHandler.chatStreamBuilder(),
    );
  }
}

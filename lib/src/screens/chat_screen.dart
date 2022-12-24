import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../provider/provider.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User otherUser = ModalRoute.of(context)!.settings.arguments as User;
    var allProvider = Provider.of<AllProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Inbox"),
      ),
      body: allProvider.repository.fireBaseHandler
          .SingleChatStreamBuilder(otherUser),
    );
  }
}

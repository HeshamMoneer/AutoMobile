import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';

class Inbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var allProvider = Provider.of<AllProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Inbox"),
      ),
      body: allProvider.repository.fireBaseHandler.chatStreamBuilder(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../models/message.dart';
import '../provider/provider.dart';
import 'chat_triangle.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatelessWidget {
  final Message curMessage;
  ChatMessage({required this.curMessage});

  bool isToday(DateTime dateToCheck) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final aDate =
        DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    return aDate == today;
  }

  String customDateFromatter(DateTime date) {
    return !isToday(date)
        ? DateFormat('yyyy-MM-dd - kk:mm').format(date)
        : DateFormat('kk:mm').format(date);
  }

  Widget messageWidget(messageText, isMine, messageDate, seen) {
    return Padding(
      padding: EdgeInsets.only(
          right: isMine ? 18 : 50, left: isMine ? 50 : 18, top: 5, bottom: 5),
      child: Tooltip(
        triggerMode: TooltipTriggerMode.tap,
        message: customDateFromatter(messageDate),
        preferBelow: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: 30),
            Flexible(
                child: Row(
              mainAxisAlignment:
                  isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isMine)
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: CustomPaint(
                      painter: Triangle(Colors.grey.shade300),
                    ),
                  ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color:
                          isMine ? Colors.grey.shade900 : Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft:
                            isMine ? Radius.circular(18) : Radius.circular(0),
                        topRight:
                            !isMine ? Radius.circular(18) : Radius.circular(0),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                    ),
                    child: Text(
                      messageText,
                      style: TextStyle(
                          color: isMine ? Colors.white : Colors.black,
                          fontFamily: 'Monstserrat',
                          fontSize: 14),
                    ),
                  ),
                ),
                if (isMine)
                  CustomPaint(painter: Triangle(Colors.grey.shade900)),
              ],
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var allProvider = Provider.of<AllProvider>(context, listen: false);
    String curUserId = allProvider.getCurrentUserId();
    bool isMine = curMessage.senderId == curUserId;
    return messageWidget(
        curMessage.content, isMine, curMessage.sentDate, curMessage.seen);
  }
}

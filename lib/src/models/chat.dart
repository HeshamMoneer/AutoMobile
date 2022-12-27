import 'message.dart';

class Chat {
  String from_userId;
  String to_userId;
  Message lastMessage;

  Chat(
      {required this.from_userId,
      required this.to_userId,
      required this.lastMessage});
}

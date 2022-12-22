import 'user.dart';
import 'message.dart';

class Chat {
  String user1Id;
  String user2Id;
  String id;
  List<Message> messages;

  Chat(
      {required this.user1Id,
      required this.user2Id,
      required this.id,
      required this.messages});
}

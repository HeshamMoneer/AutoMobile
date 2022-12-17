import 'message.dart';

class Chat {
  String user1_id;
  String user2_id;
  String id;
  List<Message> messages;

  Chat(
      {required this.user1_id,
      required this.user2_id,
      required this.id,
      required this.messages});
}

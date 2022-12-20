import 'user.dart';
import 'message.dart';

class Chat {
  User user1;
  User user2;
  String id;
  List<Message> messages;

  Chat(
      {required this.user1,
      required this.user2,
      required this.id,
      required this.messages});
}

import 'package:AutoMobile/src/models/message.dart';

import '../models/chat.dart';
import 'dto.dart';

class ChatDTO implements DTO {
  Map<String, dynamic> ModelToJson(Object model) {
    Chat chat = model as Chat;
    List<Map<String, dynamic>> messages = [];
    chat.messages.forEach((message) => messages.add({
          "content": message.content,
          "senDate": message.sentDate,
          "seen": message.seen,
          "senderId": message.senderId
        }));
    return {
      "id": chat.id,
      "user1_id": chat.user1Id,
      "user2_id": chat.user2Id,
      "lastUpdated": chat.lastUpdated,
      "messages": messages
    };
  }

  @override
  Chat? JsonToModel(Map<String, dynamic> json) {
    return null;
  }
}

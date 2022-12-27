class Message {
  String id;
  String content;
  DateTime sentDate;
  bool seen;
  String senderId;

  Message(
      {required this.id,
      required this.content,
      required this.sentDate,
      required this.seen,
      required this.senderId});
}

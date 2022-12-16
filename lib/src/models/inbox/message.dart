class Message {
  String content;
  DateTime sentDate;
  bool seen;
  String senderId;

  Message(
      {required this.content,
      required this.sentDate,
      required this.seen,
      required this.senderId});
}

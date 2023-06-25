import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String message;
  String senderId;
  DateTime timestamp;

  Message({
    required this.message,
    required this.senderId,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'senderId': senderId,
      'timestamp': timestamp.toUtc().toIso8601String(),
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      senderId: json['senderId'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class CloudChatInfo {
  final String ownerUserId;
  List<Message>? messages;

  CloudChatInfo({
    required this.ownerUserId,
    this.messages,
  });

  CloudChatInfo.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : ownerUserId = snapshot.id,
        messages = (snapshot.data()?['messages'] as List<dynamic>?)
            ?.map((item) => Message.fromJson(item))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'ownerUserId': ownerUserId,
      'messages': messages?.map((message) => message.toJson()).toList(),
    };
  }
}
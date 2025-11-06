import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderEmaiI;
  final String receiverlD;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.senderID,
      required this.senderEmaiI,
      required this.receiverlD,
      required this.message,
      required this.timestamp});
  Map<String, dynamic> tomap() {
    return {
      'senderID': senderID,
      'senderEmaiI': senderEmaiI,
      'receiverlD': receiverlD,
      'message': message,
      'Timestamp': timestamp,
    };
  }
}

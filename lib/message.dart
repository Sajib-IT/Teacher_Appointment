
import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String sendId;
  String sendName;
  String receiveId;
  String message;
  Timestamp timestamp;

  Message({
   required this.sendId,
    required this.sendName,
    required this.receiveId,
    required this.timestamp,
    required this.message
});

  Map <String , dynamic> toMap(){
    return{
      'sendId' : sendId,
      'sendName' : sendName,
      'receiveId' : receiveId,
      'message' : message,
      'timestamp' : timestamp,
    };
  }
}
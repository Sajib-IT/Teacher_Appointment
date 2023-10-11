
import 'package:appointment/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ChatService extends ChangeNotifier{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiveId ,String message) async{

  String currentUserId = firebaseAuth.currentUser!.uid;
  String currentUserName = firebaseAuth.currentUser!.displayName.toString();
  Timestamp timestamp = Timestamp.now();

  Message newMessage = Message(
      sendId: currentUserId,
      sendName: currentUserName,
      receiveId: receiveId,
      timestamp: timestamp,
      message: message
  );


  List<String> ids = [currentUserId,receiveId];
  ids.sort();
  String chatRoomId = ids.join("_");
  await firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('message')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId){
    List<String> ids = [userId,otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('message').orderBy('timestamp',descending: true)
        .snapshots();
  }

}
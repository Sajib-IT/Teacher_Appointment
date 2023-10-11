import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class AppointList extends StatefulWidget {

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  State<AppointList> createState() => _AppointListState();
}

class _AppointListState extends State<AppointList> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("Appoint List"),),
      body: buildMessageList(),
    );
  }

  Widget buildMessageList(){
    return StreamBuilder(
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Text('Error${snapshot.error}');
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return  SpinKitCircle(
            color: Colors.blue,
            size: 50,
          );
        }
        return ListView(
          children: snapshot.data!.docs.map((document) => buildMessageItem(document)).toList(),
        );
      },
      stream: getList(),

    );
  }


  Widget buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          SizedBox(height: 3,),
          Text(data['name'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28,color: Colors.blue),),
          Text(data['time'].toString(),style: TextStyle(fontSize: 18,color: Colors.teal),),
          SizedBox(height: 3,),
          Divider(),
        ],
      ),
    );
  }


  Stream<QuerySnapshot> getList(){
    return firestore
        .collection('accept')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('list').orderBy('time',descending: true)
        .snapshots();
  }
}

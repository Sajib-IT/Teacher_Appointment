import 'package:appointment/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'chat_page1.dart';

class ChatPage2 extends StatefulWidget {
  var receiveUserName;
  var receiveUserId;
  ChatPage2({this.receiveUserId, this.receiveUserName}) ;
  @override
  State<ChatPage2> createState() => _ChatPageState();
}


class _ChatPageState extends State<ChatPage2> {

  String selectedItem = 'Project';
  List options = ['Project', 'Thesis','Assignment','Counselling','Others'];
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TimeOfDay time=TimeOfDay(hour: 0, minute: 0);
  DateTime date=DateTime.now();


 String time1='',date1='';

  String msg='';
  bool visible = false;
  TextEditingController messageController = TextEditingController();
  ChatService chatService = ChatService();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
      await chatService.sendMessage(
          widget.receiveUserId, msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.receiveUserName),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Divider(),

            Container(height: 200,
                child: Expanded(child: buildMessageList())),

            SizedBox(height: 10,),
            Divider(),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed:(){
                      msg = "You are accepted in your desired time";
                      Fluttertoast.showToast(
                          msg: "Request Accepted",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: 18.0
                      );
                      sendMessage();
                       accept(date1,time1);
                    },
                    child: Text("Accept")),
                ElevatedButton(
                    onPressed: (){
                      msg = "Sorry! You are rejected";
                      Fluttertoast.showToast(
                          msg: "Request Rejected",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 18.0
                      );
                      sendMessage();
                    },
                    child: Text("Decline")),
                ElevatedButton(
                    onPressed: (){
                       visible=true;
                       setState(() {
                         visibled();
                       });

                    },
                    child: Text("Update")),
              ],
            ),
            SizedBox(height: 20,),
           Divider(),
          Container(height:0,child: fetchData()),
           visibled(),
           // Expanded(child: fetchData()),
          ],
        ),
      ),
    );
  }


  Widget visibled(){
    return Visibility(
        visible: visible,
        child: Column(
      children: [
        SizedBox(height: 10,),
        Row(
          children: [
            IconButton(
              onPressed: (){
                showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2100)).then((value) {
                  setState(() {
                    date = value!;
                  });
                });
              },
              icon: Icon(Icons.date_range,size: 45),),
            SizedBox(width: 10,),
            Text(date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString(),style: TextStyle(fontSize: 25),),

          ],
        ),
        SizedBox(height: 13,),
        Row(
          children: [
            IconButton(
                onPressed: (){
                  showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                    setState(() {
                      time = value!;
                    });
                  });
                },
                icon: Icon(Icons.access_time_filled,size: 45,)),
            SizedBox(width: 10,),
            Text(time.format(context).toString(),style: TextStyle(fontSize: 25),),
          ],
        ),
        ElevatedButton(onPressed: (){
          msg= "I would like to meet you " +" at " +time.format(context).toString()+" on "
              +date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString()
              +' for ' + selectedItem.toString();
          Fluttertoast.showToast(
              msg: "Request Updated",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.teal,
              textColor: Colors.white,
              fontSize: 18.0
          );
          sendMessage();

          String time3=time.format(context).toString();
          String date3=date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString();
          accept(date3,time3);
        },
            child: Text("send")),
        Divider()
      ],
    ));
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
      stream: chatService.getMessages(
          widget.receiveUserId, firebaseAuth.currentUser!.uid),

    );
  }

  Widget buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['sendId'] == firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data['sendName'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
          Text(data['message'],style: TextStyle(fontSize: 19),),
          SizedBox(height: 6,),
        ],
      ),
    );

  }

  Future<void> accept(String date2 , String time2) async{
    String currentUserId = firebaseAuth.currentUser!.uid;
    String currentUserName = firebaseAuth.currentUser!.displayName.toString();
    Timestamp timestamp = Timestamp.now();
    await firestore
        .collection('accept')
        .doc(currentUserId).collection('list').doc(widget.receiveUserId).set({
        'name': widget.receiveUserName,
        'timestamp' : timestamp,
         'time' : " on "+date2 + ' at '+time2

    }
    );
  }

  Widget buildMessageInput(){
    return Row(
      children: [
        Expanded(
            child:  Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey[200],
              ),
              child: TextFormField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: 'Enter your message...',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            )
        ),
        SizedBox(width: 5,),
        ElevatedButton(
          onPressed: sendMessage,
          child: Text("send"),),
      ],
    );
  }

  Widget fetchData()  {
     return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('datetime').doc(widget.receiveUserId).snapshots(),
      builder: (context,snapshot){
        final userData = snapshot.data!.data() as Map<String, dynamic>;
        time1 = userData['time'];
        date1 = userData['date'];
        return Container(
          height: 2,
        );
      },
    );
  }


}

import 'package:appointment/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatPage1 extends StatefulWidget {
  var receiveUserName;
  var receiveUserId;
  ChatPage1({this.receiveUserId, this.receiveUserName});
  @override
  State<ChatPage1> createState() => _ChatPageState();

}

class _ChatPageState extends State<ChatPage1> {

  String selectedItem = 'Project';
  List options = ['Project', 'Thesis','Assignment','Counselling','Other'];
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TimeOfDay time=TimeOfDay(hour: 0, minute: 0);
  DateTime date=DateTime.now();
 String msg = '';
 bool visible=false;

  TextEditingController otherController = TextEditingController();
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

            SizedBox(height: 30,),
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
                  icon: Icon(Icons.date_range,size: 40,),),
                SizedBox(width: 8,),
                Text(date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString(),style: TextStyle(fontSize: 20),),

              ],
            ),
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
                    icon: Icon(Icons.access_time_filled,size: 40,)),
                SizedBox(width: 8,),
                Text(time.format(context).toString(),style: TextStyle(fontSize: 20),),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              children: [
                Text('  Purpose :',style: TextStyle(fontSize: 18),),
                SizedBox(width: 12,),
                DropdownButton(
                  value: selectedItem,
                  items: options
                      .map(
                        (day) => DropdownMenuItem(
                      child: Text(day),
                      value: day,
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedItem = value.toString();
                      if(selectedItem== "Other"){
                        visible=true;
                      }
                      else{
                        visible=false;
                      }
                    });
                  },
                ),
              ],
            ),
            Visibility(
              visible: visible,
                child: otherInput()),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: (){

                  msg= "I would like to meet you " +" at " +time.format(context).toString()+" on "
                      +date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString()
                      +' for ' + selectedItem.toString();

                  Fluttertoast.showToast(
                      msg: "Request Send Successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 18.0
                  );
                  sendMessage();
                  storetimedate();
                },
                child: Text("Submit")),

            SizedBox(height: 40,),
            Divider(),
            SizedBox(height: 14,),
            Container(height: 200, child: Expanded(child: buildMessageList())),
            Divider()

          ],
        ),
      ),
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

  Widget otherInput(){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
              child:  Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.grey[200],
                ),
                child: TextFormField(
                  controller: otherController,
                  decoration: InputDecoration(
                    hintText: 'Enter your purpose...',
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
            onPressed: (){
              selectedItem = otherController.text;
            },
            child: Text("Enter"),),
        ],
      ),
    );
  }


  void storetimedate(){
    firestore.collection('datetime').doc(auth.currentUser!.uid).set(
        {
          'date' : date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString(),
          'time' : time.format(context).toString(),

        }
    );
  }

}

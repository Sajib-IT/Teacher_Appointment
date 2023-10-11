import 'package:appointment/chat_page1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
   HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var receiveUserName;
  var receiveUserID;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 28,),
          CarouselSlider(
            items: [
              Container(
                margin: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                      image: AssetImage("lib/assets/ict.jpg"),
                      fit: BoxFit.cover),
                ),
              ),
              Container(
                margin: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: AssetImage("lib/assets/first.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: AssetImage('lib/assets/tola12.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
            options: CarouselOptions(
              height: 180.0,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
          ),
          SizedBox(
            height: 100,
          ),

          Text("Teachers List ",style:TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.blue),),
          SizedBox(height: 20,),

          StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('teachers').snapshots(),
            builder: (context, snapshot) {
              List<Row> clientWidgets = [];
              if (snapshot.hasData) {
                final clients = snapshot.data?.docs.reversed.toList();

                for (var client in clients!) {
                  final clientWidget = Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: CircleAvatar(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: InkWell(
                              onTap: (){
                                Navigator.
                                of(context).push(MaterialPageRoute(
                                    builder: (ctx)=>ChatPage1(
                                      receiveUserName: client['name'],
                                      receiveUserId: client['uid'],
                                    )
                                )
                                );
                              },
                              child: Text(
                                client['name'],
                               style: TextStyle(fontSize: 20,
                                 color: Colors.teal,
                                 fontWeight: FontWeight.bold
                               ),
                              ),
                            ),
                          ),
                          radius: 58,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ],
                  );
                  clientWidgets.add(clientWidget);
                }
              }
              return Container(
                color: Colors.grey,
                height: 160,
                child: Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: clientWidgets,
                    ),
                  ),
                ),
              );
            },
          ),

        ],
      ),
    );
  }
}


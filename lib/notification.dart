

import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:appointment/show.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  void requestNotificationPermission() async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
  print("user granted permission");
    }
    else if(settings.authorizationStatus==AuthorizationStatus.provisional){
      print("user granted provision permission");
    }
    else{
      AppSettings.openAppSettings();
      print("user denied permission");
    }
  }

  void initlocalNotifications(BuildContext context, RemoteMessage message) async{
    var androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload){
         handleMessage(context, message);
      }
    );
  }

  void firebaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen((message) {
      if(kDebugMode) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
        print(message.data.toString());
        print(message.data['type']);
        print(message.data['id']);
      }
      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message)async{
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        'High Importance Notification',
        importance: Importance.max

    );
   AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
       channel.id.toString(),
       channel.name.toString(),
       channelDescription: 'your channel description',
       importance: Importance.high,
     priority: Priority.high,
     ticker: 'ticker'
   );


   NotificationDetails notificationDetails = NotificationDetails(
     android: androidNotificationDetails
   );
       Future.delayed(Duration.zero,() {
         flutterLocalNotificationsPlugin.show(
             0,
             message.notification!.title.toString(),
             message.notification!.title.toString(),
             notificationDetails
         );
       });
  }

  Future<String> getDeviceToken()async{
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async{
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print("refresh");
    });

  }

  void handleMessage(BuildContext context,RemoteMessage message){
   if(message.data['type']=='msg'){
     Navigator.push(context, MaterialPageRoute(builder: (context)=> Show(id: message.data['id'],)));
   }
  }
}
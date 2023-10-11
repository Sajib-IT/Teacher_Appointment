import 'package:appointment/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeNoti extends StatefulWidget {
  const HomeNoti({Key? key}) : super(key: key);

  @override
  State<HomeNoti> createState() => _HomeNotiState();
}

class _HomeNotiState extends State<HomeNoti> {
  NotificationService notificationService =  NotificationService();


  @override
  void initState() {
    super.initState();
    notificationService.requestNotificationPermission();
  notificationService.firebaseInit(context);
    notificationService.isTokenRefresh();

    notificationService.getDeviceToken().then((value)  {
      print("device token");
        print(value);
    });


  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("notification"),
      ),

    );
  }
}

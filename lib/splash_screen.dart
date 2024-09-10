import 'package:appointment/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  final String profession;
     const SplashScreen({super.key,this.profession=''});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2)).then((value) => {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) =>  LoginPage()))
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'lib/assets/splash.jpeg',
            width: 200,
          ),
          const SpinKitThreeInOut(
            color: Colors.blue,
            size: 40,
          ),
        ],
      ),
    );
  }
}

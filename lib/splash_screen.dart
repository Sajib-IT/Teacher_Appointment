import 'package:appointment/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((value) => {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (ctx) => const LoginPage()))
        });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('lib/assets/splash.jpeg'),
              width: 300,
            ),
            SizedBox(
              height: 50,
            ),
            SpinKitThreeInOut(
              color: Colors.blue,
              size: 50,
            ),
            SizedBox(
              height: 170,
            ),
            Text('\n\n© Tech Group. All Rights Reserved.',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text('\nDeveloped By: Tech Titans',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple)),
          ],
        ),
      ),
    );
  }
}

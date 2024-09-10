import 'package:appointment/splash_screen.dart';
import 'package:appointment/splash_sreen2.dart';
import 'package:appointment/widgets/flutter_toast.dart' as toast;
import 'package:appointment/widgets/my_dropdown_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  String? selectedType ;
  List types = ['Teacher', 'Student'];

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool passToggle = true;
  bool isLoading = false;
  toast.FlutterToast flutterToast = toast.FlutterToast() ;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(height:200,width: 200, child: Image.asset('lib/assets/login.jpeg', width: 150)),
              const SizedBox(
                height: 16,
              ),
              MyDropdownButton(
                  value: widget.selectedType,
                  items: widget.types,
                  hint: "Select Profession",
                  onChanged: (v) {
                    widget.selectedType = v;
                  }),
              const SizedBox(
                height: 16
              ),
              TextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    label: Text("Email", style: TextStyle(fontSize: 16)),
                    // hintText: 'Enter Email',
                    prefixIcon: Icon(Icons.email),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    )),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                obscureText: passToggle,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          passToggle = !passToggle;
                        });
                      },
                      child: Icon(passToggle
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                    label: const Text("Password",
                        style: TextStyle(fontSize: 16)),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24.0),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    )),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Material(
                  elevation: 5.0,
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    onPressed: () async {
                      if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty && widget.selectedType!=null){
                        if ((widget.selectedType == 'Teacher' && await fireStoreDataValidation('teachers'))
                            || (widget.selectedType == 'Student' && await fireStoreDataValidation('students'))) {
                          flutterToast.toastMessage(msg: "Successfully Logged in");
                          goRoute(context);
                        }else{
                          flutterToast.toastMessage(msg: "Wrong email or Password",bgColor: Colors.red);
                        }
                      }else{
                        flutterToast.toastMessage(msg: " Please fill all field ",bgColor: Colors.white24,textColor: Colors.black);
                      }
                    },

                    child: !isLoading ? const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ): const CircularProgressIndicator(),
                  ),
                ),
              ),
              const SizedBox(
                height: 6.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?  "),
                  InkWell(
                    child: const Text(
                      "Register now",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "register");
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<bool> fireStoreDataValidation(String collectionName) async{
    setState(() {
      isLoading = true;
    });

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(collectionName).get();
    for(var doc in querySnapshot.docs){
      if(doc.get('email') == emailController.text && doc.get('pass') == passwordController.text){
        return true;
      }
    }
    setState(() {
      isLoading = false;
    });

    return false;
  }
  void goRoute(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) =>
            SplashScreen2( widget.selectedType!)));
  }
}

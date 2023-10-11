import 'package:flutter/material.dart';

class Show extends StatefulWidget {
  final String id;
  const Show({Key? key,required this.id}) : super(key: key);

  @override
  State<Show> createState() => _ShowState();
}

class _ShowState extends State<Show> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("show message"+ widget.id),),
    );
  }
}

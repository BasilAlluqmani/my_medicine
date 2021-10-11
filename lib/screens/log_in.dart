import 'dart:async';
import 'package:my_medicine1/screens/sign_in.dart';
import 'package:my_medicine1/screens/tab_bar.dart';


import 'package:flutter/material.dart';

class LogIn_Screen extends StatefulWidget {
  @override
  _LogIn_ScreenState createState() => _LogIn_ScreenState();
}

class _LogIn_ScreenState extends State<LogIn_Screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 4000),(){
     return Navigator.pushReplacement(context, MaterialPageRoute(builder: (con){
         return TabBarS() ;
      }));

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.green, Colors.greenAccent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter)),
        child:Center(child:CircleAvatar(backgroundImage: AssetImage('image/logo.png'),radius: 90 ,),),
      ),
    );
  }
}

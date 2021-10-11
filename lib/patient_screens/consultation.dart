import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_medicine1/patient_screens/patient_cons/consulatation1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_medicine1/patient_screens/test.dart';
import 'dart:io';

class Consultation extends StatefulWidget {
  String _id;
  Consultation(this._id);
bool b=false;
bool list=false;
  @override
  _ConsultationState createState() => _ConsultationState();
}

class _ConsultationState extends State<Consultation> {
  List item=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:
          AppBar(title: Text('Consultation'), automaticallyImplyLeading: false),
      body: Center(child: RaisedButton(child: Text('Boutton',style: TextStyle(color: Colors.white),),color: Colors.green,onPressed: (){
        Navigator.of(context).pushNamed('consPage',arguments: widget._id);
      },),));

  }
}

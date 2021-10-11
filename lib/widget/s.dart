import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';




class s extends StatefulWidget{
  @override
  _sState createState() => _sState();
}

class _sState extends State<s> {
  @override
  Widget build(BuildContext context) {
    int  d=1;int sd=6600001;
    return Scaffold(body: Center(child: RaisedButton(child: Text('Add'),onPressed: (){
     setState(() {
       Firestore.instance.collection('Hospitals').document('King Faisal Hospital').collection('pharmacist').document(sd.toString()+d.toString()).setData(
           {
             'Date':'',
             'Nationality':'Saudi',
             'Work_Date':'',
             'city':'makkah',
             'id':sd.toString()+d.toString(),
             'name':'nawaf ahmed',
             'password':'12345678',
             'phone':'0588822283',
             'sex':'male',
           });
     });
   },),),);
  }
}


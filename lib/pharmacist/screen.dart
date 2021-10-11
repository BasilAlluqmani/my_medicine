import 'package:flutter/material.dart';
import 'package:my_medicine1/doctor/chat.dart';
import 'package:my_medicine1/doctor/cons_req.dart';
import 'package:my_medicine1/doctor/profail.dart';
import 'package:my_medicine1/doctor/add_medicine.dart';
import 'package:my_medicine1/doctor/selecte_pat.dart';
import 'package:my_medicine1/pharmacist/Delivery.dart';
import 'package:my_medicine1/pharmacist/Receipt_hospital.dart';
import 'package:my_medicine1/pharmacist/profila.dart';





class PharmacistPages extends StatefulWidget{
  @override
  _PharmacistPagesState createState() => _PharmacistPagesState();
}


class _PharmacistPagesState extends State<PharmacistPages> {


  int index=0;

  void Selsct(int indx){
    setState(() {
      index=indx;
    });

  }

  @override
  Widget build(BuildContext context) {
    final route =
    ModalRoute.of(context).settings.arguments as Map<String,Object> ;
    List<Map<String,Object>>Page=[
      {'page':Receipt_hospital(route['ID'],route['Hospital']),},
      {
        'page':Delivery_hospital(route['ID'],route['Hospital']),},
      {
        'page':ProfailP(route['ID'],route['Hospital']),}
    ];
    return Scaffold(
      body: Page[index]['page'],
      bottomNavigationBar:BottomNavigationBar(
        unselectedItemColor: Colors.greenAccent,
        selectedItemColor: Colors.greenAccent,
        currentIndex: index,
        type: BottomNavigationBarType.shifting,
        onTap:Selsct ,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.post_add_outlined),title: Text('Receive'),),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car),title: Text('Deliver'),),
          BottomNavigationBarItem(icon: Icon(Icons.perm_identity_rounded),title: Text('Profail'),)
        ],),
    );

  }
}
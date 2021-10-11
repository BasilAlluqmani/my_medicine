import 'package:flutter/material.dart';
import 'package:my_medicine1/doctor/chat.dart';
import 'package:my_medicine1/doctor/cons_req.dart';
import 'package:my_medicine1/doctor/profail.dart';
import 'package:my_medicine1/doctor/add_medicine.dart';
import 'package:my_medicine1/doctor/selecte_pat.dart';




class DoctorPages extends StatefulWidget{
  @override
  _DoctorPagesState createState() => _DoctorPagesState();
}


class _DoctorPagesState extends State<DoctorPages> {


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
      {'page':SelectePa(route['ID'],route['Hospital'],route['Specialty']),},
      {
        'page':Consultation(route['ID']),},
      {
        'page':Chat(route['ID']),},
      {
        'page':Profile(route['ID'],route['Hospital'],route['Specialty']),}
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
          BottomNavigationBarItem(icon: Icon(Icons.medical_services_outlined),title: Text('ADD Medicine'),),
          BottomNavigationBarItem(icon: Icon(Icons.post_add),title: Text('Consultation'),),
          BottomNavigationBarItem(icon: Icon(Icons.chat_outlined),title: Text('Chat'),),
          BottomNavigationBarItem(icon: Icon(Icons.perm_identity_rounded),title: Text('Profail'),)
        ],),
    );

  }
}
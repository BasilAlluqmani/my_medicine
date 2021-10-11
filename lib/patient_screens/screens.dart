import 'package:flutter/material.dart';
import 'package:my_medicine1/patient_screens/medicine.dart';
import 'package:my_medicine1/patient_screens/consultation.dart';
import 'package:my_medicine1/patient_screens/chat.dart';
import 'package:my_medicine1/patient_screens/patient_cons/hodpital.dart';
import 'package:my_medicine1/patient_screens/profail.dart';
import 'package:my_medicine1/screens/tab_bar.dart';
import 'package:my_medicine1/patient_screens/patient_cons/hospital.dart';



class First extends StatefulWidget{
  @override
  _FirstState createState() => _FirstState();
}


class _FirstState extends State<First> {


  int index=0;

  void Selsct(int indx){
    setState(() {
      index=indx;
    });

  }

  @override
  Widget build(BuildContext context) {
    final routarg =
    ModalRoute.of(context).settings.arguments as String ;

    List<Map<String,Object>>Page=[
      {'page':Medicine(routarg),'title':'Medicine'},
      {
        'page':MainHospital(routarg),'title':'Consultation'},
      {
        'page':Chat(routarg),'title':'Chat'},
      {
        'page':Profail(routarg)}
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
          BottomNavigationBarItem(icon: Icon(Icons.medical_services_outlined),title: Text('Medicine'),),
          BottomNavigationBarItem(icon: Icon(Icons.category_outlined),title: Text('Consultation'),),
          BottomNavigationBarItem(icon: Icon(Icons.chat_outlined),title: Text('Chat'),),
          BottomNavigationBarItem(icon: Icon(Icons.perm_identity_rounded),title: Text('Profail'),)
        ],),
    );

  }
}
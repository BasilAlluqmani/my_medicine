import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_medicine1/widget/cons1.dart';
import 'package:my_medicine1/patient_screens/test.dart';

class ConslitationPage1 extends StatefulWidget {
  @override
  _ConslitationPage1State createState() => _ConslitationPage1State();
}

class _ConslitationPage1State extends State<ConslitationPage1> {
  String value1=null;
  String value2=null;
  String DoctorCh;
  bool _Switch=false;
  bool _State=false;
  @override
  // TODO: implement widget
  // TODO: implement widget
  @override
  Widget build(BuildContext context) {
    List menue1=['AlnoorHospital'];
    List menue2 = ['Dentist Doctor','General Doctor','Orthopedic Doctor'];
    final routarg =
    ModalRoute.of(context).settings.arguments as String ;
setState(() {
  if(value1!=null&&value2!=null){
    _Switch=true;
  }
});



    return Scaffold(
      appBar: AppBar(title: Text('Consultation'),),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(15)),
                child: DropdownButton(
                  isExpanded: true,
                  hint: Text('Choose Hospital'),
                  value: value1,
                  onChanged: (new_value) {
                    setState(() {
                      value1 = new_value;
                      print(value1);
                    });
                  },
                  items: menue1.map((valueItem) {
                    return DropdownMenuItem(
                        value: valueItem, child: Text(valueItem));
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(15)),
                child: DropdownButton(
                  isExpanded: true,
                  hint: Text('Choose Doctor Specialty'),
                  value: value2,
                  onChanged: (new_value) {
                    setState(() {
                      value2 = new_value;
                      print(value2);
                    });
                  },
                  items: menue2.map((valueItem) {
                    return DropdownMenuItem(
                        value: valueItem, child: Text(valueItem));
                  }).toList(),
                ),
              ),
            ),
            if(_Switch)
            DrList(value1,value2,routarg),

          ],
        ),
      ),
    );
  }

}

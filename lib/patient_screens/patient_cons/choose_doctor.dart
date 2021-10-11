import 'package:flutter/material.dart';
import 'package:my_medicine1/patient_screens/patient_cons/hodpital.dart';
import 'package:my_medicine1/widget/cons1.dart';

class ChooseDoctor extends StatefulWidget{
  String Hospital_Id;
  String Doctor_sp;
  String PID;
  ChooseDoctor(this.Hospital_Id,this.Doctor_sp,this.PID);
  @override
  _ChooseDoctorState createState() => _ChooseDoctorState();
}

class _ChooseDoctorState extends State<ChooseDoctor> {
  @override
  Widget build(BuildContext context) {
    print(widget.Hospital_Id);
    return Scaffold(appBar: AppBar(title:Text(widget.Doctor_sp)),
    body:DrList(widget.Hospital_Id,widget.Doctor_sp,widget.PID),
    );



  }
}
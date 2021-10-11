import 'package:flutter/material.dart';
import 'package:my_medicine1/doctor/setting.dart';
import 'package:my_medicine1/patient_screens/Deliver_m.dart';
import 'package:my_medicine1/patient_screens/consultation.dart';
import 'package:my_medicine1/patient_screens/current_m.dart';
import 'package:my_medicine1/patient_screens/patient_cons/cons_ref.dart';
import 'package:my_medicine1/pharmacist/Data_Delivery.dart';
import 'package:my_medicine1/pharmacist/Delivery.dart';
import 'package:my_medicine1/pharmacist/Patient_records.dart';
import 'package:my_medicine1/pharmacist/Receipt_hospital.dart';
import 'package:my_medicine1/pharmacist/screen.dart';
import 'package:my_medicine1/pharmacist/stting.dart';
import 'package:my_medicine1/screens/log_in.dart';
import 'package:my_medicine1/screens/tab_bar.dart';
import 'package:my_medicine1/patient_screens/patient_cons/consulatation1.dart';
import 'package:my_medicine1/patient_screens/patient_cons/consulatation1.dart';
import 'package:my_medicine1/screens/sign_in.dart';
import 'package:my_medicine1/patient_screens/screens.dart';
import 'package:my_medicine1/patient_screens/profail.dart';
import 'package:my_medicine1/patient_screens/consultation.dart';
import 'package:my_medicine1/patient_screens/patient_cons/hospital.dart';
import 'package:my_medicine1/patient_screens/patient_cons/doctor_type.dart';
import 'package:my_medicine1/doctor/screen.dart';
import 'package:my_medicine1/patient_screens/test.dart';
import 'package:my_medicine1/doctor/screen.dart';
import 'package:my_medicine1/doctor/test2.dart';
import 'package:my_medicine1/widget/basstest.dart';
import 'package:my_medicine1/doctor/add_medicine.dart';
import 'package:my_medicine1/widget/s.dart';
import 'package:my_medicine1/widget/testbad.dart';
import 'package:my_medicine1/doctor/selecte_pat.dart';
import 'package:my_medicine1/doctor/add_medicine.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyMedicineApp',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LogIn_Screen(),
      routes: {
        'PFirt':(ctx)=>First(),
        'PDoctor':(ctx)=>DoctorPages(),
        'consPage':(ctx)=>ConslitationPage1(),
        'AddMedicine':(ctx)=>AddMedicine(),
        'SignUp':(ctx)=>Create_account(),
        'Stting':(ctx)=>settings(),
        'SttingP':(ctx)=>settingsP(),
        'SttingD':(ctx)=>settingsD(),
        'Tap':(ctx)=>TabBarS(),


        'Pharmacist':(ctx)=>PharmacistPages(),


      },
    );
  }
}

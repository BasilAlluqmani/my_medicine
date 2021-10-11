import 'package:flutter/material.dart';
class MedicineData{
  String MedicineName;
  int amount;
  int Quantity;
  String MedicineType;
  double Dose;
  DateTime dateTime;

  MedicineData({@required this.MedicineName,@required this.amount,@required this.Quantity,
    @required this.MedicineType,@required this.Dose,@required this.dateTime});

}
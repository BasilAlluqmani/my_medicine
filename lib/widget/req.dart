import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:my_medicine1/patient_screens/patient_cons/cons_ref.dart';

class DataReq extends StatelessWidget {
  var doc ;
  var item ;

  int index;
  List conState = [];

  DataReq(this.doc, this.index, this.conState);

  String Da(Timestamp date) {
    final Timestamp timestamp = date as Timestamp;
    DateTime d = timestamp.toDate();
    String s = '';
    s = DateFormat('yyyy-MM-dd').format(d);
    DateTime nd = DateTime.parse(s);
    Duration dur = DateTime.now().difference(nd);
    String difference = (dur.inDays / 365).floor().toString();
    return difference;
  }

  /*String ٍٍٍdata12(bool conState,bool conState2) {
    if(conState==false&&conState2==false)
      return 'Rejected';
    else if(conState==true&&conState2==false)
      return 'In Waiting';
    else if(conState==false&&conState2==true)
      return 'Closed';
    else if(conState==true&&conState2==true)
      return 'Open';
    else return 'null';
  }*/

  @override
  Widget build(BuildContext context) {

  }
}

String Consstate(ConsultationStatus, ConsultationAccepted) {
  if (ConsultationStatus == false && ConsultationAccepted == false)
    return 'Rejected';
  else if (ConsultationStatus == true && ConsultationAccepted == false)
    return 'In Waiting';
  else if (ConsultationStatus == false && ConsultationAccepted == true)
    return 'Closed';
  else if (ConsultationStatus == true && ConsultationAccepted == true)
    return 'Open';
  else
    return 'null';
}

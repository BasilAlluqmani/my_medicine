import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_medicine1/doctor/consultation_list.dart';

import 'package:intl/intl.dart';


class test1 extends StatefulWidget{
  String id;
  bool _switch=true;
  bool sw=false;

  @override
  _test1State createState() => _test1State();
}

class _test1State extends State<test1> {
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
  var dataCons = [];
  var dataConsAccept = [];
  List docmeuntConsAccept=[];




  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Consultation requests'),),
      body:StreamBuilder(stream:Firestore.instance
          .collection('consultation')
          .where('DrId', isEqualTo: '60000101').where('ConsultationAccepted',isEqualTo: false).where('ConsultationStatus',isEqualTo: true).snapshots() ,builder:(con,snap){
          if(snap.hasData){
          return ListView.builder(
            itemBuilder: (ctx, index) {
              return StreamBuilder(stream: Firestore.instance.collection('Patient').document(snap.data.documents[index]['patientId']).snapshots(),builder: (ctx,snap2){
               if(snap2.hasData){
                 return Container(
                   margin: EdgeInsets.only(left: 5, right: 5),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(5.0),
                     color: Colors.white,
                     boxShadow: [
                       BoxShadow(
                         color: Colors.green,
                         offset: Offset(0.0, 1.0), //(x,y)
                         blurRadius: 6.0,
                       ),
                     ],
                   ),
                   width: double.infinity,
                   height: MediaQuery.of(context).size.height * 0.17,
                   child: Text(snap2.data['name']),

                 );

               }
            return   Container(child: Text('No Data'),);
              });
            },
            itemCount: 1,
          );}

        if(ConnectionState.waiting==snap.connectionState){
         return CircularProgressIndicator();
        }

        return Center(child: Text("No Data"),);

      } ,),

    );

  }
}
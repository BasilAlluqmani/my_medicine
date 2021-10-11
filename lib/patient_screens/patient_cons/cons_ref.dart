import 'dart:collection';
import 'dart:convert';
import 'package:my_medicine1/widget/req.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:my_medicine1/patient_screens/consultation.dart';
import 'package:my_medicine1/patient_screens/patient_cons/hospital.dart';

class consList extends StatefulWidget {
  String id;
  consList(this.id);

  @override
  _consListState createState() => _consListState();
}

class _consListState extends State<consList> {
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
  String Da1(Timestamp date) {
    final Timestamp timestamp = date as Timestamp;
    DateTime d = timestamp.toDate();
    String s = '';
    s = DateFormat('yyyy-MM-dd-hh-mm').format(d);

    return s;
  }
  int _CurrentRate=0;
  Widget satrIcon(int i){
    return _CurrentRate>i?Icon(Icons.star,color:Colors.yellow ,):Icon(Icons.star_border);
  }



  @override
  void initState() {
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    final _star=List<Widget>.generate(5, (index){
      return GestureDetector(child:satrIcon(index),onTap: (){
        setState(() {
          _CurrentRate=index+1;
          RateData(_CurrentRate);

          print(_CurrentRate);
        });
      }
      );
    });


    return Scaffold(
      appBar: AppBar(
        title: Text('Consultation requests'),
      ),
      body:StreamBuilder(
        stream: Firestore.instance
            .collection('consultation')
            .where('patientId', isEqualTo: widget.id).orderBy("Date",descending: true).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              itemBuilder: (ctx, i) {
                return StreamBuilder(stream: Firestore.instance.collection('/Hospitals/${snapshot.data.documents[i]['hospital']}/Specialty/${snapshot.data.documents[i]['Specialty']}/ID').document(snapshot.data.documents[i]['DrId']).snapshots(),builder: (ctx,snap2){
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
                      child: Card(
                        elevation: 5,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 10),
                              child: Row(
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width * 0.4,
                                      child: Text(
                                        'Dr: ' +
                                            snap2.data['name'] ,
                                        style: TextStyle(
                                            fontSize: 17, fontWeight: FontWeight.w300),
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 10),
                              child: Row(
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: Text(
                                        snap2.data['Nationality'],
                                        style: TextStyle(
                                            fontSize: 12, fontWeight: FontWeight.w300),
                                      )),
                                  Container(
                                      width: MediaQuery.of(context).size.width * 0.32,
                                      child: Text(
                                        'Experience:  ' + Da(snap2.data['Work_Date']),
                                        style:
                                        TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                                      )),
                                  Container(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: Text(
                                        snap2.data['specialty'],
                                        style: TextStyle(
                                            fontSize: 12, fontWeight: FontWeight.w300),
                                      )),
                                ],
                              ),
                            ),
                            Row(
                              children: [

                                Container(
                                    margin: EdgeInsets.only(left: 10, top: 10),
                                    width: MediaQuery.of(context).size.width * 0.27,
                                    child: Text(
                                      'Sex:  ' + snap2.data['sex'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(left: 10, top: 10),
                                    width: MediaQuery.of(context).size.width * 0.35,
                                    child: Text(
                                       Da1(snapshot.data.documents[i]['Date']),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(left: 10, top: 10),
                                    width: MediaQuery.of(context).size.width * 0.15,
                                    child: Text(
                                      Consstate(snapshot.data.documents[i]['ConsultationStatus'],
                                          snapshot.data.documents[i]['ConsultationAccepted']),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          color: snapshot.data.documents[i]['ConsultationStatus'] ==
                                              true &&
                                              snapshot.data.documents[i]['ConsultationAccepted'] ==
                                                  false ||
                                              snapshot.data.documents[i]['ConsultationStatus'] ==
                                                  true &&
                                                  snapshot.data.documents[i]['ConsultationAccepted'] ==
                                                      true
                                              ? Colors.green
                                              : Colors.red),
                                    )),
                              ],
                            ),

                          ],
                        ),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Container();
                }
                );
              },
              itemCount: snapshot.data.documents.length,
            );

          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Container();

        }
    ),
    );
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
  Future RateData(int d) async {
    await Firestore.instance.collection('consultation').document('Rgw3SEiGimgADWu56slW').updateData({'Rate':d}).whenComplete(() => RateUpdate());
  }
  Future RateUpdate()async{
    int rateNum=0;int RateLen=0;
    await Firestore.instance.collection('consultation').where('DrId',isEqualTo: '60000102').getDocuments().then((value){
      value.documents.forEach((element) {
        rateNum=rateNum+element.data['Rate'];
      });
      RateLen= value.documents.length;

    } );
    await Firestore.instance.collection(
        '/Hospitals/AlnoorHospital /Specialty/Dentist Doctor/ID').document('60000102').updateData({
      'Rate':_CurrentRate/RateLen,
      'peopleRate':RateLen,

    });
  }
}

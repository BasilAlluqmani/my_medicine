import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_medicine1/doctor/consultation_list.dart';

import 'package:intl/intl.dart';

class Consultation extends StatefulWidget {
  String id;
  Consultation(this.id);
  bool _switch = true;

  @override
  _ConsultationState createState() => _ConsultationState();
}

class _ConsultationState extends State<Consultation> {
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

  String Date2(Timestamp date) {
    final Timestamp timestamp = date as Timestamp;
    DateTime d = timestamp.toDate();
    String s = '';
    s = DateFormat('yyyy-MM-dd-h-mm').format(d);
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Consultation requests'),
          automaticallyImplyLeading: false),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('consultation')
              .where('DrId', isEqualTo: widget.id)
              .where('ConsultationAccepted', isEqualTo: false)
              .where('ConsultationStatus', isEqualTo: true)
              .snapshots(),
          builder: (ctx, consultationData) {
            if (consultationData.hasData) {
              return ListView.builder(
                itemBuilder: (ctx, index) {
                  return StreamBuilder(
                      stream: Firestore.instance
                          .collection('Patient')
                          .document(consultationData.data.documents[index]
                              ['patientId'])
                          .snapshots(),
                      builder: (ctx, PatinetData) {
                        if (PatinetData.hasData) {
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
                                            width: MediaQuery.of(context).size.width * 0.8,
                                            child: Text(
                                              PatinetData.data['name'],
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w300),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10, top: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context).size.width * 0.7,
                                            child: Text(
                                              'Date: ' +
                                                  Date2(consultationData.data.documents[index]['Date']),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300),
                                            )),
                                        Container(
                                            width: MediaQuery.of(context).size.width * 0.2,
                                            child: Text(
                                              'Age: ' +
                                                  Da(PatinetData.data['Date']),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: MediaQuery.of(context).size.width * 0.6),
                                        width:
                                            MediaQuery.of(context).size.width * 0.2,
                                        child: IconButton(
                                          icon: Icon(Icons
                                              .assignment_turned_in_outlined),
                                          onPressed: () {
                                            Firestore.instance
                                                .collection('consultation')
                                                .document(consultationData
                                                    .data
                                                    .documents[index]
                                                    .documentID)
                                                .updateData({
                                              'ConsultationAccepted': true
                                            }).whenComplete(() => Firestore.instance.collection(
                                                '/consultation/${consultationData.data.documents[index].documentID}/chat').add({
                                                      'time': DateTime.now(),
                                                      'type': 'text'
                                                    }));
                                          },
                                          color: Colors.green,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.cancel_presentation),
                                        onPressed: () {
                                          Firestore.instance
                                              .collection('consultation')
                                              .document(consultationData.data
                                                  .documents[index].documentID)
                                              .updateData({
                                            'ConsultationStatus': false
                                          });
                                        },
                                        color: Colors.red,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        if (ConnectionState.waiting ==
                            consultationData.connectionState) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Container();
                      });
                },
                itemCount: consultationData.data.documents.length,
              );
            }
            if (ConnectionState.waiting == consultationData.connectionState) {
              return Center(child: CircularProgressIndicator());
            }
            return Container();
          }),
    );
  }
}

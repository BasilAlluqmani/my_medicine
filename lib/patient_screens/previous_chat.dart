import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_medicine1/patient_screens/patient_cons/prrevious_chat_conv.dart';

class PreviousConsulting extends StatefulWidget {
  String _id;
  PreviousConsulting(this._id);

  @override
  _PreviousConsultingState createState() => _PreviousConsultingState();
}

class _PreviousConsultingState extends State<PreviousConsulting> {
  int _CurrentRate = 0;

  Widget satrIcon(int i) {
    return _CurrentRate > i
        ? Icon(
            Icons.star,
            color: Colors.yellow,
          )
        : Icon(Icons.star_border);
  }

  Widget satrIconYell() {
    return Icon(Icons.star, color: Colors.yellow);
  }

  Widget satrIcon2() {
    return Icon(Icons.star_border_rounded);
  }

  String Da(Timestamp date) {
    final Timestamp timestamp = date as Timestamp;
    DateTime d = timestamp.toDate();
    String s = '';
    s = DateFormat('yyyy-MM-dd-hh-m').format(d);
    return s;
  }

  @override
  Widget build(BuildContext context) {
    Widget Yellowstar(int numberOfStar) {
      int count = 0;
      final _Yellowstar = List<Widget>.generate(5, (_) {
        count = count + 1;
        return count <= numberOfStar ? satrIconYell() : satrIcon2();
      });
      return Row(
        children: _Yellowstar,
      );
    }

    Widget starNull() {
      final _Yellowstar = List<Widget>.generate(5, (_) {
        return satrIcon2();
      });
      return Row(
        children: _Yellowstar,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Chat'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('consultation')
            .where('patientId', isEqualTo: widget._id)
            .where('ConsultationAccepted', isEqualTo: true)
            .where('ConsultationStatus', isEqualTo: false).orderBy("Date",descending: true)
            .snapshots(),
        builder: (con, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemBuilder: (ctx, index) {
                return StreamBuilder(
                    stream: Firestore.instance
                        .collection(
                            '/Hospitals/${snap.data.documents[index]['hospital']}/Specialty/${snap.data.documents[index]['Specialty']}/ID')
                        .document(snap.data.documents[index]['DrId'])
                        .snapshots(),
                    builder: (ctx, snap2) {
                      if (snap2.hasData) {
                        return InkWell(
                          onTap: () => Navigator.push(con,
                              MaterialPageRoute(builder: (con) {
                            return ChatPageClose(
                                snap.data.documents[index]['DrId'],
                                widget._id,
                                snap.data.documents[index].documentID,
                                snap2.data['name'],
                                snap.data.documents[index]['hospital'],
                                snap.data.documents[index]['Specialty'],
                                snap.data.documents[index]['Rate']);
                          })),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: Card(
                              child: Row(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.13,
                                    child: FittedBox(
                                      child: Icon(
                                        Icons.supervised_user_circle_sharp,
                                        color: Colors.green,
                                      ),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01,
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                "Dr " + snap2.data['name'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w200),
                                              ))),
                                      StreamBuilder(
                                          stream: Firestore.instance
                                              .collection('consultation')
                                              .document(snap.data
                                                  .documents[index].documentID)
                                              .collection('chat')
                                              .orderBy('time', descending: true)
                                              .snapshots(),
                                          builder: (ctx, time) {
                                            if (time.hasData) {
                                              return Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  child: FittedBox(
                                                      fit: BoxFit.fitWidth,
                                                      child: Text(
                                                        Da(time.data
                                                                .documents[0]
                                                            ['time']),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w200),
                                                      )));
                                            }
                                            return Container();
                                          }),
                                      Row(
                                        children: [
                                          snap.data.documents[index]['Rate'] == 0 ? starNull() : Yellowstar(snap.data.documents[index]['Rate']),
                                          snap.data.documents[index]['Rate'] == 0 ? Text('Not Rated', style: TextStyle(color: Colors.red)) : Text('Rated', style: TextStyle(color: Colors.green),),
                                          ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    });
              },
              itemCount: snap.data.documents.length,
            );
          }

          if (ConnectionState.waiting == snap.connectionState) {
            return Center(child: CircularProgressIndicator());
          }

          return Container();
        },
      ),
    );
  }
}

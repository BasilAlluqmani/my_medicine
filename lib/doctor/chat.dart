import 'package:my_medicine1/doctor/previous_cons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_medicine1/doctor/test2.dart';

class Chat extends StatelessWidget {
  String _id;
  Chat(this._id);

  @override
  Widget build(BuildContext context) {
    String Da(Timestamp date) {
      final Timestamp timestamp = date as Timestamp;
      DateTime d = timestamp.toDate();
      String s = '';
      s = DateFormat('yyyy-MM-dd-h-mm').format(d);
      return s;
    }

    return Scaffold(
      appBar: AppBar(title: Text('Chat'), automaticallyImplyLeading:
      false,actions: [IconButton(icon: Icon(Icons.mark_chat_read_sharp,), onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return PreviousConsulting(_id);
        }));
      })],),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('consultation')
            .where('DrId', isEqualTo: _id)
            .where('ConsultationAccepted', isEqualTo: true)
            .where('ConsultationStatus', isEqualTo: true)
            .snapshots(),
        builder: (con, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemBuilder: (ctx, index) {
                return StreamBuilder(
                    stream: Firestore.instance
                        .collection('Patient')
                        .document(snap.data.documents[index]['patientId'])
                        .snapshots(),
                    builder: (ctx, snap2) {
                      if (snap2.hasData) {
                        return InkWell(
                          onTap: () => Navigator.push(con,
                              MaterialPageRoute(builder: (con) {
                            return Test1(
                                _id,
                                snap.data.documents[index]['patientId'],
                                snap.data.documents[index].documentID,snap2.data['name'],snap.data.documents[index]['hospital'],snap.data.documents[index]['Specialty']);
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
                                              bottom: MediaQuery.of(context).size.height * 0.01,
                                              top: MediaQuery.of(context).size.height * 0.01),
                                          width: MediaQuery.of(context).size.width * 0.35,
                                          child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                snap2.data['name'],
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
                                                  width: MediaQuery.of(context).size.width * 0.25,
                                                  child: FittedBox(
                                                      fit: BoxFit.fitWidth,
                                                      child: Text(Da(time.data.documents[0]['time']),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w200),
                                                      )));
                                            }
                                            return Container();

                                          })
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return Container(
                      );

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

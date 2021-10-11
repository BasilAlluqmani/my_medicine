import 'package:my_medicine1/patient_screens/previous_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_medicine1/patient_screens/patient_cons/chat_page.dart';

class Chat extends StatefulWidget {
  String _id;
  Chat(this._id);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {


  @override
  Widget build(BuildContext context) {
    String Da(Timestamp date) {
      final Timestamp timestamp = date as Timestamp;
      DateTime d = timestamp.toDate();
      String s = '';
      s = DateFormat('yyyy-MM-dd-hh-MM').format(d);
      return s;
    }
    return Scaffold(
      appBar: AppBar(title: Text('Chat'), automaticallyImplyLeading: false,actions: [IconButton(icon: Icon(Icons.mark_chat_read_sharp,), onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return PreviousConsulting(widget._id);
        }));
      })],),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('consultation')
            .where('patientId', isEqualTo: widget._id)
            .where('ConsultationAccepted', isEqualTo: true)
            .where('ConsultationStatus', isEqualTo: true)
            .snapshots(),
        builder: (con, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemBuilder: (ctx, index) {
                return StreamBuilder(
                    stream: Firestore.instance
                        .collection('/Hospitals/${snap.data.documents[index]['hospital']}/Specialty/${snap.data.documents[index]['Specialty']}/ID')
                        .document(snap.data.documents[index]['DrId'])
                        .snapshots(),
                    builder: (ctx, snap2) {
                      if (snap2.hasData) {
                        return InkWell(
                          onTap: () => Navigator.push(con,
                              MaterialPageRoute(builder: (con) {
                                return ChatPage(
                                    widget._id,
                                    snap.data.documents[index]['DrId'],
                                    snap.data.documents[index].documentID,snap2.data['name']);
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
                                              child: Text('Dr '+
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
                                                      child: Text(Da(time.data.documents[time.data.documents.length-1]['time']),
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .w200),
                                                      )));
                                            }
                                            return Container();

                                          }),

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

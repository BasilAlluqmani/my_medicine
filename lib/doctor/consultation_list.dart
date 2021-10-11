import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class ConsultationList extends StatefulWidget{
  var doc = <Map>[];
  int index;
  var dataConsAccept = <Map>[];
  List docmeuntConsAccept=[];


  ConsultationList(this.doc, this.index,this.dataConsAccept,this.docmeuntConsAccept);

  @override
  _ConsultationListState createState() => _ConsultationListState();
}

class _ConsultationListState extends State<ConsultationList> {
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

  @override
  Widget build(BuildContext context) {
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
                            widget.doc[widget.index]['name']
                           ,
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
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text('Date: '+
                        widget.dataConsAccept[widget.index]['Date'].toDate().toString(),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300),
                      )),Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Text('Age:: '+
                          Da(widget.doc[widget.index]['Date']),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300),
                      )),

                ],
              ),
            ),
            Row(
              children: [
                Container(margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.6),width: MediaQuery.of(context).size.width*0.2,
                  child: IconButton(icon: Icon(Icons.assignment_turned_in_outlined), onPressed: (){
                setState(() {
                  Firestore.instance.collection('consultation').document(widget.docmeuntConsAccept[widget.index]).updateData(
                      {'ConsultationAccepted':true});
                });

                  },color: Colors.green,),
                ),
                IconButton(icon: Icon(Icons.cancel_presentation), onPressed: (){
                    Firestore.instance.collection('consultation').document(widget.docmeuntConsAccept[widget.index]).updateData(
                        {'ConsultationStatus':false});


                },color: Colors.red,)

              ],
            ),
          ],
        ),
      ),
    );
  }
}
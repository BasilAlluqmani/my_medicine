import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';




class Pervious extends StatefulWidget {
  String id;

  Pervious(this.id);

  @override
  _PerviousState createState() => _PerviousState();
}

class _PerviousState extends State<Pervious> {
  @override
  Widget build(BuildContext context) {
    String Da(Timestamp date) {
      final Timestamp timestamp = date as Timestamp;
      DateTime d = timestamp.toDate();
      String s = '';
      s = DateFormat('yyyy-MM-dd-hh-mm').format(d);
      return s;
    }
    return Scaffold(
        body: StreamBuilder(stream: Firestore.instance.collection('/Patient/${widget.id}/Patient_records').where('ExpiryDate',isLessThan: DateTime.now()).snapshots(),builder: (ctx,s){

          if(s.hasData){

            return ListView.builder(itemCount: s.data.documents.length,itemBuilder:(ctx,i){
              return Container(color: Colors.grey,width: double.infinity,child: Card(child: Row(children: [
                Icon(Icons.medical_services_rounded,color: Colors.green,size: MediaQuery.of(context).size.width*0.20,),
                Column(crossAxisAlignment: CrossAxisAlignment.start,children: [Container(margin: EdgeInsets.only(top:3),child: Text(s.data.documents[i]['MedicineName'],style: TextStyle(fontWeight: FontWeight.w300),)),Container(margin: EdgeInsets.only(top:3,bottom: 3),child: Row(children: [Container(width: MediaQuery.of(context).size.width*0.35,child: Text('Dally Dose :'+s.data.documents[i]['DallyDose'].toString(),style: TextStyle(fontWeight: FontWeight.w300))),Text('Dose :'+s.data.documents[i]['Dose'].toString(),style: TextStyle(fontWeight: FontWeight.w300)),])),
                  Container(margin: EdgeInsets.only(bottom: 3),child: Row(children: [Container(width: MediaQuery.of(context).size.width*0.35,child: Text('Type :'+s.data.documents[i]['MedicineType'],style: TextStyle(fontWeight: FontWeight.w300))),Text('Quantity :'+s.data.documents[i]['MedicineQuantity'].toString(),style: TextStyle(fontWeight: FontWeight.w300))],)),
                  Container(width: MediaQuery.of(context).size.width*0.7,margin: EdgeInsets.only(bottom: 3),child: Text('Expiry date :'+Da(s.data.documents[i]['ExpiryDate'],),style: TextStyle(fontWeight: FontWeight.w300)))
                ],),
              ],)));
            });
          }else if(ConnectionState.waiting==s.connectionState){
            return Center(child: CircularProgressIndicator());
          }else if(s.data.documents.length==0){
            return Center(child: Container(child: Text('No Medicine'),));
          }
          return Container();

        },));
  }
}
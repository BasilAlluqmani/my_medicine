import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:my_medicine1/widget/image_container.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_medicine1/doctor/image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
class PreviousConsChat extends StatefulWidget {

  String _DrId,_PId,_ConId,DName,h,s,d;
  PreviousConsChat(this._DrId,this._PId,this._ConId,this.DName,this.d,this.h,this.s);


  @override
  _PreviousConsChatState createState() => _PreviousConsChatState();
}


class _PreviousConsChatState extends State<PreviousConsChat> {
  void _showDialog(BuildContext context) {
    // flutter defined function

  }




  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String Da(Timestamp date) {
      final Timestamp timestamp = date as Timestamp;
      DateTime d = timestamp.toDate();
      String s = '';
      s = DateFormat('yyyy-MM-dd-h-mm').format(d);
      return s;
    }
    String Da1(Timestamp date) {
      final Timestamp timestamp = date as Timestamp;
      DateTime d = timestamp.toDate();
      String s = '';
      s = DateFormat('yyyy-MM-dd').format(d);
      DateTime nd = DateTime.parse(s);
      Duration dur = DateTime.now().difference(nd);
      String difference = (dur.inDays / 365).floor().toString();
      return difference;
    }
    return Scaffold(appBar: AppBar(title:Container(width: MediaQuery.of(context).size.width*0.7,child: FittedBox(fit: BoxFit.fitWidth,child: Text(widget.DName+' Chat Room'))),actions: [
      IconButton(icon: Icon(Icons.add_box_outlined), onPressed: (){
        Navigator.of(context).pushNamed('AddMedicine',arguments:
        {'Name':widget.DName,'Age':widget.d,'hospital':widget.h,'Sph':widget.s,'Id':widget._DrId,'PID':widget._PId});
    })
      ],),
      body: Container(
        child: Column( children: [
          Expanded(
            child:StreamBuilder(stream: Firestore.instance.collection('/consultation/${widget._ConId}/chat').orderBy('time',descending: true).snapshots(),builder: (ctx,snap){
              if(snap.hasData){
                return ListView.builder(shrinkWrap: true,reverse: true,itemCount: snap.data.documents.length,itemBuilder: (ctx,ind){
                  var fromMe=snap.data.documents[ind]['from']==widget._DrId;
                  return Row(mainAxisAlignment:ind==snap.data.documents.length-1?MainAxisAlignment.center:fromMe?MainAxisAlignment.end:MainAxisAlignment.start,children: [
                    Container(constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.7),decoration: BoxDecoration(color:fromMe?Colors.greenAccent:Colors.grey[200],borderRadius: BorderRadius.circular(5),),padding: EdgeInsets.symmetric(horizontal:5 ,vertical:5),margin: EdgeInsets.symmetric(horizontal:16 ,vertical:10), child:
                    snap.data.documents[ind]['type']=='image'?NewImageNetwork(snap.data.documents[ind]['url']):Text(ind==snap.data.documents.length-1?Da(snap.data.documents[ind]['time']):snap.data.documents[ind]['content'],style: TextStyle(color: Colors.white),),)
                  ],


                  );
                });
              }
              if(ConnectionState.waiting==snap.connectionState){
                return CircularProgressIndicator();
              }

              return Center(child: Text("No Data"),);

            }),
          ),

            Container(height:MediaQuery.of(context).size.height*0.10,
              margin: EdgeInsets.symmetric(horizontal:5 ,vertical:5),
              child: FittedBox(child:Card(elevation: 6,child: Row(children: [
                Icon(Icons.warning_amber_outlined,color: Colors.red,),
                Text('The consultation is closed',style: TextStyle(fontWeight: FontWeight.w300),)
              ],),),),

            ),

        ],),
      ),
    );
  }

}



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
import 'package:path_provider/path_provider.dart';
class ChatPageClose extends StatefulWidget {
  String _DrIr,_PId,_ConId,DName;String _hospital;String _Specialty;var Rate;
  ChatPageClose(this._DrIr,this._PId,this._ConId,this.DName,this._hospital,this._Specialty,this.Rate);

  @override
  _ChatPageCloseState createState() => _ChatPageCloseState();
}


class _ChatPageCloseState extends State<ChatPageClose> {
  int _CurrentRate=0;
  Widget satrIconYell(){
    return Icon(Icons.star,color:Colors.yellow);
  }
  Widget satrIcon2(){
    return Icon(Icons.star_border_rounded);

  }
  Widget satrIcon(int i){
    return _CurrentRate>i?Icon(Icons.star,color:Colors.yellow ,):Icon(Icons.star_border);
  }
  Widget ConsultationClose(){
    return Container(height:MediaQuery.of(context).size.height*0.10,
      margin: EdgeInsets.symmetric(horizontal:5 ,vertical:5),
      child: FittedBox(child:Card(elevation: 6,child: Row(children: [
        Icon(Icons.warning_amber_outlined,color: Colors.red,),
        Text('The consultation is closed',style: TextStyle(fontWeight: FontWeight.w300),)
      ],),),),

    );
  }
  Widget onTapStar(String doc,String DrId,String hospital,String Specialty){
    final _star=List<Widget>.generate(5, (index){
      return GestureDetector(child:satrIcon(index),onTap: (){
        setState(() {
          _CurrentRate=index+1;
          RateData(_CurrentRate,doc,DrId,hospital,Specialty);
          Navigator.of(context).pop();
        });
      }
      );
    });
    return Row(mainAxisAlignment: MainAxisAlignment.center,children: _star,);
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Rating",textAlign: TextAlign.center,),
          content: Container(height: MediaQuery.of(context).size.height*0.20,
            child: Column(
              children: [
                Text('How you rate your consultation with Dr ${widget.DName} of 5',textAlign: TextAlign.center),
                SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                onTapStar(widget._ConId,widget._DrIr,widget._hospital,widget._Specialty)
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.Rate==0?Timer.run(() => _showDialog()):null;
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
    print(widget._hospital+widget._Specialty+widget._DrIr);

    return Scaffold(appBar: AppBar(title:Text('Dr '+widget.DName+' Chat Room')),
      body: Container(
        child: Column( children: [
          Expanded(
            child:StreamBuilder(stream: Firestore.instance.collection('/consultation/${widget._ConId}/chat').orderBy('time',descending: true).snapshots(),builder: (ctx,snap){
              if(snap.hasData){
                return ListView.builder(shrinkWrap: true,reverse: true,itemCount: snap.data.documents.length,itemBuilder: (ctx,ind){
                  var fromMe=snap.data.documents[ind]['from']==widget._PId;
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
          ConsultationClose(),
        ],),
      ),
    );
  }
  Future RateData(int CurrentRate,String doc,String DrId,String hospital,String Specialty) async {
    await Firestore.instance.collection('consultation').document(doc).updateData({'Rate':CurrentRate})
    .whenComplete(() => RateUpdate(DrId,hospital,Specialty));
    setState(() {
    });
  }
  Future RateUpdate(String DrId,String hospital,String Specialty)async{
    int rateNum=0;int RateLen=0;
    await Firestore.instance.collection('consultation').where('DrId',isEqualTo: DrId).getDocuments().then((value){
      value.documents.forEach((element) {
        if(element.data['Rate']!=0){
          rateNum=rateNum+element.data['Rate'];
          RateLen=RateLen+1;
        }
      });

    } );
   await Firestore.instance.collection('/Hospitals/$hospital/Specialty/$Specialty/ID').document(DrId).updateData({
      'Rate':rateNum/RateLen,
      'peopleRate':RateLen,
    });
  }
}




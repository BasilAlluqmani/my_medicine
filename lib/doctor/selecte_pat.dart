import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';




class SelectePa extends StatefulWidget{
  String ID,Hospital,sph;
  SelectePa(this.ID, this.Hospital,this.sph);

  @override
  _SelectePaState createState() => _SelectePaState();
}

class _SelectePaState extends State<SelectePa> {
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
  String NEwID='';
  String _ID='';
  String id='';
  String Name='';
  String age;
  bool _s=false;
  bool _sw=false;

  var _formKey=GlobalKey<FormState>();



  void Access(BuildContext con) {
    Navigator.of(context).pushNamed('AddMedicine',arguments:
    {'Name':Name,'Age':age,'hospital':widget.Hospital,'Sph':widget.sph,'Id':widget.ID,'PID':_ID});
  }
    @override
    Widget build(BuildContext context) {
      final _textController = TextEditingController();
      return Scaffold(
        appBar: AppBar(automaticallyImplyLeading:
        false,title: Text('Add Medicine'),), body: SingleChildScrollView(
          child : Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          Form(key: _formKey,
            child: TextFormField(decoration: InputDecoration(
                prefixIcon: Icon(Icons.perm_identity_rounded),
                labelText: "Enter Patient ID"), validator: (val) {
              if (val.isEmpty || val.length != 10) {
                return 'please enter valid id';
              }
              return null;
            },
              onSaved: (val) {
                _ID = val;
              }, maxLength: 10,),),
          _sw?StreamBuilder(stream: Firestore.instance.collection('Absher').where('id',isEqualTo: _ID)
              .snapshots(),builder: (ctx,s){
            if(s.hasData&&s.data.documents.length!=0){
              age=Da(s.data.documents[0]['Date']);
              Name=s.data.documents[0]['name'];

              _s=true;
              return GestureDetector(onTap:()=>Access(context),
                child: Container(width: double.infinity,
                  child: Card(elevation: 5,child: Row(children: [Icon(Icons.perm_identity_rounded,color: Colors.green,
                    size: MediaQuery.of(context).size.width*0.1,),
                    Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                      Container(margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.01),
                      child: Text('Name: ' +s.data.documents[0]['name'],
                        style: TextStyle(fontWeight: FontWeight.w300),)),
                      Container(margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.01),
                          child:Text('ID: ' +s.data.documents[0]['id'],style: TextStyle(fontWeight: FontWeight.w300),)),
                      Container(margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.01),
                   child:Text('Age: ' +Da(s.data.documents[0]['Date']),style: TextStyle(fontWeight: FontWeight.w300),)),

                    ],),
                  ],)),
                ),
              );
            }else {_s=false;
              return Text('No Data');}

          }):Container(),
      ],),
        ),floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          setState(() {
            final isValid = _formKey.currentState.validate();
            FocusScope.of(context).unfocus();
            _formKey.currentState.save();
            if(isValid){
              _sw=true;
            }
          });
        },
        child: const Icon(Icons.search),
        backgroundColor: Colors.green,
      ),);

    }
  }
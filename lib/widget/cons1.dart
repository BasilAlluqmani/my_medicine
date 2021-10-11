import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:my_medicine1/patient_screens/consultation.dart';
import 'package:my_medicine1/patient_screens/patient_cons/hospital.dart';
import 'package:my_medicine1/patient_screens/screens.dart';



class DrList extends StatefulWidget {
  Widget satrIcon(){
    return Icon(Icons.star,color:Colors.yellow);
  }
  Widget satrIcon2(){
    return Icon(Icons.star_border_rounded);

  }
  String value1;
  String value2;
  String id;
  DrList(this.value1, this.value2,this.id);
  List listItem=null;
   Future consreq() async {
      CollectionReference ref= await Firestore.instance.collection('consultation').where('patientId',isEqualTo: id).where('ConsultationStatus',isEqualTo: true).getDocuments().then((v){
      v.documents.forEach((element) {
        listItem.add(element.data);
      });
      });

  }

  @override
  _DrListState createState() => _DrListState();
  
}

class _DrListState extends State<DrList> {

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

  List newlist=[];
  bool Switchresult=false;
@override
  void initState() {
    // TODO: implement initState
  super.initState();
    fetch();
    print(widget.listItem);
  }

  fetch()async{
    dynamic result =await widget.consreq();
    if(widget.listItem==null){
      Switchresult=true;
      print('null');
    }
    else{
      setState(() {
        newlist=result;
      });

    }
  }
  @override
  Widget build(BuildContext context) {
    Widget Yellowstar(int numberOfStar){
      int count=0;
      final _Yellowstar=List<Widget>.generate(5, (_){
        count=count+1;
        return count<=numberOfStar?widget.satrIcon():widget.satrIcon2();
      });
      return Row(children: _Yellowstar,);
    }
    final _star2=List<Widget>.generate(5, (_){
      return widget.satrIcon2();
    });
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.9,
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('/Hospitals/'+widget.value1+'/Specialty/'+widget.value2+'/ID')
            .snapshots(),
        builder: (ctx, snapshot){
          if(snapshot.hasData){
            var doc = snapshot.data.documents;

            return ListView.builder(
                itemBuilder: (ctx, index) {

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
                    height: MediaQuery.of(context).size.height * 0.18,
                    child: Card(
                      elevation: 5,
                      child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 10),
                              child: Row(
                                children: [
                                  Container(
                                      width:
                                      MediaQuery.of(context).size.width * 0.8,
                                      child: Text(
                                        'Dr: ' +
                                            doc[index]['name'],
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
                                      width:
                                      MediaQuery.of(context).size.width * 0.30,
                                      child: Text(
                                        doc[index]['Nationality'],
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300),
                                      )),
                                  Container(
                                      width: MediaQuery.of(context).size.width * 0.25,
                                      child: Text(
                                        'Sex:  ' + doc[index]['sex'],
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300),
                                      )),
                                  Container(
                                      width:
                                      MediaQuery.of(context).size.width * 0.25,
                                      child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child:Text(
                                            doc[index]['specialty'],
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300),
                                          ))),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(left: 10, top: 10),
                                    width: MediaQuery.of(context).size.width * 0.25,
                                    child: Text(
                                      'Experience:  ' + Da(doc[index]['Work_Date']),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                    )),
                                doc[index]['peopleRate']==0? Container( margin: EdgeInsets.only( top: 10),

                                  child: Row(children: [
                                    Row(children: _star2),
                                    Container(margin: EdgeInsets.only(left:5),width:MediaQuery.of(context).size.width*0.15 ,child: FittedBox(fit: BoxFit.fitWidth,child: Text('Rate: None'))),
                                  ],),
                                ):Container(margin: EdgeInsets.only(top: 10),
                                  child: Row(children: [Yellowstar(doc[index]['Rate'].floor()),
                                    Container(margin: EdgeInsets.only(left:5),width:MediaQuery.of(context).size.width*0.15 ,child: FittedBox(fit: BoxFit.fitWidth,child:Text('Rate: '+doc[index]['Rate'].toString()))),
                                  ],
                                  ),
                                ),

                                IconButton(
                                  icon: Icon(Icons.post_add_sharp),
                                  onPressed: () {
                                    print(doc[index]['id']+widget.id);
                                    return showDialog(context: context,builder: (context){
                                      return AlertDialog(
                                        title: Text('Request consulation'),
                                        content: Text('Are you sure you want to request a consultation from Dr '+doc[index]['name']),
                                        actions: [
                                          MaterialButton(color: Colors.red,onPressed: (){Navigator.of(context).pop();
                                          print(Switchresult);   },child: Text('No',style: TextStyle(color: Colors.white),),),

                                          MaterialButton(color: Colors.green,onPressed: (){
                                            if(Switchresult==true){
                                              Navigator.of(context).pop();

                                              Firestore.instance.collection("consultation").add({
                                                'DrId':doc[index]['id'],
                                                'hospital':widget.value1,
                                                'Specialty':widget.value2,
                                                'patientId':widget.id,
                                                'ConsultationStatus':true,
                                                'ConsultationAccepted':false,
                                                'Date':DateTime.now(),
                                                'Rate':0
                                              });
                                              Navigator.of(context).pushReplacementNamed('PFirt',arguments:widget.id);

                                            }else{
                                              return showDialog(context: context,builder: (context){
                                                return AlertDialog(
                                                  title: Text('consultation Faild'),
                                                  content: Text('You already have sent consultation The response will be in one day'),
                                                  actions: [
                                                    MaterialButton(color: Colors.red,onPressed: (){Navigator.of(context).pop();
                                                    Navigator.of(context).pushReplacementNamed('PFirt',arguments:widget.id);

                                                    },child: Text('Exit',style: TextStyle(color: Colors.white),),),
                                                  ],
                                                );});
                                            }

                                          },child: Text('Yes',style: TextStyle(color: Colors.white),),),
                                        ],
                                      );

                                    });

                                  },
                                  color: Colors.green,
                                )
                              ],
                            ),

                          ]
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data.documents.length);
          }
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return Container();
        },
      ),
    );
  }


}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:my_medicine1/patient_screens/screens.dart';



class ProfailP extends StatefulWidget {
  String routarg='';
  String hospital='';

  ProfailP(this.routarg,this.hospital);

  @override
  _ProfailPState createState() => _ProfailPState();


}


class _ProfailPState extends State<ProfailP> {


  @override

  Widget build(BuildContext context) {

    String Da(Timestamp date) {
      final Timestamp timestamp = date as Timestamp;
      DateTime d = timestamp.toDate();
      String s = '';
      s = DateFormat('yyyy-MM-dd').format(d);
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


    return Scaffold(appBar: AppBar(title: Text('Profile'),automaticallyImplyLeading: false,actions: [
      IconButton(icon: Icon(Icons.settings), onPressed: (){
        Navigator.of(context).pushNamed('SttingP',arguments: {'id':widget.routarg,'h':widget.hospital});

      }),
    ],),

      body: StreamBuilder(stream: Firestore.instance.collection('/Hospitals/${widget.hospital}/pharmacist').document(widget.routarg).snapshots(),builder: (ctx,pr){
        if(pr.hasData){
          return SingleChildScrollView(
            child: Container(
              child: Column(children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100)),
                      gradient: LinearGradient(
                          colors: [Colors.green, Colors.greenAccent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter)),
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Center(
                    child: CircleAvatar(
                      backgroundImage: AssetImage('image/logo.png'),
                      radius: MediaQuery.of(context).size.height * 0.1,
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02),
                    height: MediaQuery.of(context).size.height * 0.65,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Card(
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [Card(elevation: 5,child: Text("Profile",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: MediaQuery.of(context).devicePixelRatio*13))),],),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: MediaQuery.of(context).devicePixelRatio*4,right: MediaQuery.of(context).devicePixelRatio*4),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            child: Text(
                              "Name: "+pr.data['name'],
                              style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w400,
                                  fontSize:
                                  MediaQuery.of(context).devicePixelRatio * 6.5),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: MediaQuery.of(context).devicePixelRatio*4,right: MediaQuery.of(context).devicePixelRatio*4),                      width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            child: Text(
                              "Experience:  : "+Da1(pr.data['Work_Date']),
                              style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w400,
                                  fontSize:
                                  MediaQuery.of(context).devicePixelRatio * 6.5),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Container(
                              margin: EdgeInsets.only(left: MediaQuery.of(context).devicePixelRatio*4,right: MediaQuery.of(context).devicePixelRatio*4),                        width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: Text(
                                "Phone: "+pr.data['phone'],
                                style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w400,
                                    fontSize:
                                    MediaQuery.of(context).devicePixelRatio *
                                        6.5),
                              )),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Container(
                              margin: EdgeInsets.only(left: MediaQuery.of(context).devicePixelRatio*4,right: MediaQuery.of(context).devicePixelRatio*4),                        width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: Text(
                                "Nationality: "+pr.data['Nationality'],
                                style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w400,
                                    fontSize:
                                    MediaQuery.of(context).devicePixelRatio *
                                        6.5),
                              )),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Container(
                              margin: EdgeInsets.only(left: MediaQuery.of(context).devicePixelRatio*4,right: MediaQuery.of(context).devicePixelRatio*4),                        width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: Text(
                                "Data: "+Da(pr.data['Date']),
                                style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w400,
                                    fontSize:
                                    MediaQuery.of(context).devicePixelRatio *
                                        6.5),
                              )),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Container(
                              margin: EdgeInsets.only(left: MediaQuery.of(context).devicePixelRatio*4,right: MediaQuery.of(context).devicePixelRatio*4),                        width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),

                              child: Text(
                                "Age: "+Da1(pr.data['Date']),
                                style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w400,
                                    fontSize:
                                    MediaQuery.of(context).devicePixelRatio *
                                        6.5),
                              )),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Container(
                              margin: EdgeInsets.only(left: MediaQuery.of(context).devicePixelRatio*4,right: MediaQuery.of(context).devicePixelRatio*4),                        width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: Text(
                                "Sex: "+pr.data['sex'],
                                style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w400,
                                    fontSize:
                                    MediaQuery.of(context).devicePixelRatio *
                                        6.5),
                              )),
                        ],
                      ),
                    )),
              ]),
            ),
          );
        }
        if(ConnectionState.waiting==pr.connectionState){
          Center(child: CircularProgressIndicator());
        }
        return Center(child: Text('No Wifi'),);
      },
      ),
    );
  }
}

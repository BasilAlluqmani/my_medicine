
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Data_Delivery extends StatefulWidget {
  @override
  final userId,userName,userCity,userPhone,h;
  Data_Delivery({@required this.userId,this.userName,this.userCity,this.userPhone,this.h});

  @override
  _Data_DeliveryState createState() => _Data_DeliveryState();
}

class _Data_DeliveryState extends State<Data_Delivery> {
  DateTime nowDate = new DateTime.now();

  String user_id, medicine, quantity;

  String userName,userCity,userPhone;

  bool delivery_update = true;
  Timestamp date;

  String timestamp;

  int random_code;

  TextEditingController medicine_text = TextEditingController();
  void initState(){

    super.initState();

  }


  Stream<QuerySnapshot> getmedication(BuildContext context) async* {
    yield*Firestore.instance.
    collection("Patient").document(widget.userId).
    collection("Patient_records").where("Done", isEqualTo: false).
    where("DeliveryType",isEqualTo: "Deliver").where('hospaital',isEqualTo: widget.h).snapshots();
  }


  Future<void> update_done(delivery_update, user_id) async {
    await Firestore.instance.
    collection("Patient").document(widget.userId).
    collection("Patient_records").document(medicine).
    updateData({"Done": delivery_update});
  }


  Future<String> createDialog(BuildContext context){
    return showDialog(context: context,builder: (context){
      return AlertDialog(

        title: Text("Update",style: TextStyle(fontSize: 30),),
        content: Text("Do you want to add medicine?",style: TextStyle(fontSize: 21),),

        actions: <Widget>[
          MaterialButton(onPressed: (){

            Navigator.of(context).pop();},
            child: Icon(Icons.exit_to_app,size: 40,color: Colors.red,),

          ),
          MaterialButton(
            child: Icon(Icons.add_box_outlined,size: 40,color: Colors.green,),
            onPressed: (){
              update_done(delivery_update, user_id);//كلاس تغير قيم done
              print("Name Hospiatl :"); print("Name Dr :");
              print("Name Medicine :$medicine");
              print("#$quantity");print("#$date");
              print("Code #$random_code");


              Navigator.of(context).pop();
            },
          )
        ],
      );
    }
    );
  }

  user_information() {
    print("Date #$nowDate");

   print("ID :${widget.userId}");
    print("#$date");
    print("Name :${widget.userName}");
    print("City :${widget.userCity}");
    print("Phone :${widget.userPhone}");
    print("medicine :$medicine");
    print("quantity :$quantity");
    print("Code # :$random_code");


  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Medicines"),


      ),
      body: Container(

        child: Column(
          children: <Widget>[
            Card(

              child:Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(" ${widget.userName}",style: TextStyle(fontSize: 22.0),),
                    SizedBox(width: 10,),
                    Text("${widget.userId}",style: TextStyle(fontSize: 22.0)),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10,),

         Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream:getmedication(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Text("Error: ${snapshot.error}");

                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child:
                          CircularProgressIndicator(),);

                        default:
                        return new ListView(
                          children: snapshot.data.documents
                              .map((DocumentSnapshot document) {

                            return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                              margin: EdgeInsets.all(8.0), elevation: 4,

                              child: Column(children: <Widget>[

                                  ListTile(
                                    title: new Text(document['MedicineName'], style: TextStyle(fontSize: 22),),

                                    leading:Icon(Icons.medical_services_outlined, size: 50, color: Colors.green,),

                                   subtitle: Text("Type :# ${document['MedicineType']}",
                                     style: TextStyle(fontSize: 22),),),
                                  SizedBox(height: 5,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                    children: <Widget>[IconButton(icon: Icon(Icons.print),
                                          onPressed: () {
                                            medicine = document.documentID;
                                            user_information();

                                    }),
                                      IconButton(
                                        icon: Icon(Icons.directions_car), onPressed: () {
                                        medicine = document.documentID;
                                          createDialog(context);},),
                                    ],),

                                ],
                              ),
                            );
                          }).toList(),
                        );
                    }
                  }


              ),
            ),

          ],
        ),

      ),


    );
  }
}

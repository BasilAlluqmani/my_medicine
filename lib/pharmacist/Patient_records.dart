import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class user_data extends StatelessWidget {
  @override
  var nowDate = new DateTime.now();

  final userId;
  final userName;
  user_data({@required this.userId,this.userName});

  String user_id;
  bool delivery_update =true;
  String medicine,quantity;
  Timestamp date;
  int random_code;

  TextEditingController medicine_text=TextEditingController();

  Stream<QuerySnapshot>getMedication(BuildContext context) async*{
      yield*Firestore.instance.
      collection("Patient").
      document(userId).collection("Patient_records").
     where("Done",isEqualTo: false).
      where("DeliveryType",isEqualTo:"Receive").snapshots();
  }


  Future<void> update_done ( delivery_update , user_id,newDate) async {
    await Firestore.instance.
    collection("Patient").document(userId).
    collection("Patient_records").document(medicine).
    updateData({"Done":delivery_update,'ExpiryDate':newDate});

  }


  Future<String> createDialog(BuildContext context, DateTime newDate){
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
              update_done(delivery_update, user_id,nowDate);//كلاس تغير قيم done
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

  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Medicines Record",
         ),


      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Card(
              child:Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text("ID :${userId}",style: TextStyle(fontSize: 22.0),),
                    SizedBox(width: 20,),
                    Text("Name :${userName}",style: TextStyle(fontSize: 22.0)),
                  ],
                   ),
              ),
            ),

            SizedBox(height: 10,),

              Expanded(child: StreamBuilder<QuerySnapshot>(
                    stream:getMedication(context),
                    // ignore: missing_return
                    builder: (context,snapshot) {
                      if (snapshot.hasError)
                        return Text("Error: ${snapshot.error}");
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(),);

                        default:

                          return new ListView(
                            children: snapshot.data.documents
                                .map((DocumentSnapshot document){
                                  return  Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0)),
                                    elevation: 4,
                                    margin: EdgeInsets.all(10),
                                      child: ListTile(
                                        title: new Text(document['MedicineName'],
                                          style: TextStyle(fontSize: 25.0),),
                                        subtitle: Text("Type : ${document['MedicineType'].toString()}",
                                        style: TextStyle(fontSize: 23,color: Colors.black),),

                                      leading: Icon(Icons.medical_services_outlined, size: 50, color: Colors.green,),

                                      trailing: IconButton(icon: Icon(Icons.add, color: Colors.green, size: 50.0,),
                                    onPressed:() {
                                    quantity = document['MedicineType'].toString();
                                    medicine = document.documentID;
                                    date=document['Date'];
                                    double f=(document['MedicineQuantity']/(document['Dose']*document['DallyDose']));
                                    showDialog(context: context,builder: (context){
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
                                              update_done(delivery_update, user_id,DateTime.now().add(Duration(days:f.round())));//كلاس تغير قيم done
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


                                    }),

                              )
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


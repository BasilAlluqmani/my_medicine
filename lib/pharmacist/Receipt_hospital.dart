
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Patient_records.dart';
class Receipt_hospital extends StatelessWidget {
 String id;String hospital;
  Receipt_hospital(this.id, this.hospital);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          accentColor: Colors.cyan

      ),
      home: Receipt_medicine(id,hospital),
    );
  }
}


class Receipt_medicine extends StatefulWidget {
  String id; String hospital;
  Receipt_medicine(String id, String hospital);


  @override
  _Receipt_medicineState createState() => _Receipt_medicineState();
}

class _Receipt_medicineState extends State<Receipt_medicine> {
  var selectedCurrency;

  String user_name,user_id,user_city,user_phone;

  bool delivery_update =true;
  String medicine;
  TextEditingController id_text=TextEditingController();


  Stream<QuerySnapshot>getPatient_id(BuildContext context) async*{

    if(id_text.text!=""){//is notEmpty
      yield*Firestore.instance.
      collection("Patient").where("id",isEqualTo: id_text.text).snapshots();
    }else{
      yield* Firestore.instance.
      collection("Patient").snapshots();
    }
    }

//معلومات المريض و الانتقال لواجهة ادوية المريض
  userData(){
    DocumentReference documentReference=
    Firestore.instance.
    collection("Patient").document(user_id);
    documentReference.get().then((datasnapshot){

      user_name=datasnapshot.data["name"];
      user_city=datasnapshot.data["city"];
      user_phone=datasnapshot.data["phone"];
      Navigator.push(
          context,
          MaterialPageRoute
            (builder:
              (context) =>user_data(userId: user_id,userName: user_name,)));

    });



  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Receive Medicine",
          ),
      ),

      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: id_text,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0,),),),
                      filled: true,
                      prefixIcon: IconButton(icon: Icon(Icons.search)),
                      hintText: 'Enter id Patient',),
                  onChanged: (val){setState(() {/* user_id=val;*/});}
              ),
            ),
            SizedBox(height: 10.0,),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:getPatient_id(context),
                // ignore: missing_return
                builder: (context,snapshots){
                  if (snapshots.hasData){

                    return  ListView.builder(
                      itemCount: snapshots.data.documents.length,
                      itemBuilder: (context,i){
                        return StreamBuilder(
                          stream:
                          Firestore.instance.
                          collection("/Patient/${snapshots.data.documents[i].documentID}/Patient_records").
                          where("Done",isEqualTo: false).
                          where("DeliveryType",isEqualTo: "Receive").where('hospaital',isEqualTo:widget.hospital).snapshots(),
                          builder: (context,snapshot2){
                            if(ConnectionState.waiting ==snapshot2.connectionState){
                              return Center(child:CircularProgressIndicator(),);}
                            if (snapshots.hasData){
                              if(!snapshot2.data.documents.isEmpty){
                                return Card(
                                  child: Column(
                                    children: <Widget>[
                                      new ListTile(
                                        title: new Text(snapshots.data.documents[i].documentID,
                                          style: TextStyle(fontSize: 22),),

                                        /* subtitle: Text("ID ${document['id'].toString()}",
                                       style: TextStyle(fontSize: 22,color: Colors.black),),
                                        isThreeLine: true,*/

                                        leading: Icon(
                                          Icons.perm_identity_rounded,
                                          size: 50, color: Colors.green,),

                                        trailing:Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 40, color: Colors.green,),

                                        onTap: (){
                                          user_id=snapshots.data.documents[i].documentID;
                                          userData();
                                        },),

                                    ],),
                                );
                              }
                            }
                            return Container(color: Colors.grey,);
                          },);
                      },);
                  }
                  return Container();

                }

              ),
            ),
          ],
        ),
      ),
    );

  }
}

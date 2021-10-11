
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_medicine1/pharmacist/Data_Delivery.dart';



class Delivery_hospital extends StatelessWidget {
  String id,h;
  Delivery_hospital(this.id, this.h);



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          accentColor: Colors.cyan
      ),
      home: Delivery(id,h),
    );
  }
}


class Delivery extends StatefulWidget {
  String id; String h;
  Delivery(this.id,this.h);

  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  @override
  void initState(){

    super.initState();
  }



  String user_name,user_id,user_city,user_phone;
  TextEditingController id_text=TextEditingController();





  userData(){
    DocumentReference documentReference=
    Firestore.instance.
    collection("Patient").
    document(user_id);
    documentReference.get().then((datasnapshot){

      user_name=datasnapshot.data["name"];
      user_city=datasnapshot.data["city"];
      user_phone=datasnapshot.data["phone"];

      Navigator.push(
          context,
          MaterialPageRoute
            (builder:
              (context) =>Data_Delivery(
            userId: user_id,userName: user_name,
            userCity: user_city,userPhone: user_phone,h: widget.h,)));

    });



  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Delivery Medicines "),

      ),

      body: Container(
        child: Column(
          children: <Widget>[


            SizedBox(height: 10,),


            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:Firestore.instance.
                collection("Patient").snapshots(),
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
                          where("DeliveryType",isEqualTo: "Deliver").
                          where("Done",isEqualTo: false).where('hospaital',isEqualTo: widget.h).snapshots(),
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

                                          user_id=snapshots.data.documents[i].documentID;//user_name=document['name'];
                                          userData();

                                        },),

                                      Padding(
                                        padding: const EdgeInsets.only(left: 100),
                                        child: Row(
                                          children: <Widget>[

                                          ],
                                        ),
                                      )
                                    ],),
                                );
                              }
                            }
                            return Container(color: Colors.grey,);
                          },);
                      },);
                  }
                  return Container();


                },

              ),
            ),
          ],
        ),
      ),
    );

  }
}

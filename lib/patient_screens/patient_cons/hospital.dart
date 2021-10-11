import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_medicine1/patient_screens/patient_cons/hodpital.dart';
import 'package:my_medicine1/patient_screens/patient_cons/doctor_type.dart';
import 'package:my_medicine1/patient_screens/patient_cons/cons_ref.dart';



class MainHospital extends StatefulWidget{
  String id;
  MainHospital(this.id);
  @override
  _MainHospitalState createState() => _MainHospitalState();
}
class _MainHospitalState extends State<MainHospital> {
  List listItem=[];
  List listItem3=[];

  Future consreq() async {
    CollectionReference ref= await Firestore.instance.collection('Hospitals').getDocuments().then((v){
      v.documents.forEach((element) {
        listItem.add(element.data);
        listItem3.add(element.documentID.toString());
      });
    });


  }
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();

  }
  fetch()async{
    dynamic result =await consreq();
    if(listItem==null){
      print('null');
    }
    else{
      setState(() {

      });

    }
  }
  @override
  Widget build(BuildContext context) {
    print(listItem);
    print(listItem3);

    return Scaffold(appBar: AppBar(title: Text('Hospital'),automaticallyImplyLeading: false,actions: [IconButton(icon: Icon(Icons.article_outlined), onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (con){
      return consList(widget.id) ;
    }));})],),

         body: ListView.builder(
              itemBuilder: (ctx, index) {
                return Hospital(listItem[index]['Name'],listItem3[index],widget.id);
    },
    itemCount: listItem.length,
    ),
    );

  }
}
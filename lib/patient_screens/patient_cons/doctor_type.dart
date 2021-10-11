import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_medicine1/patient_screens/patient_cons/choose_doctor.dart';

class DoctorType extends StatefulWidget{
  String Id;String title;String Pid;
DoctorType(this.Id,this.title,this.Pid);


  @override
  _DoctorTypeState createState() => _DoctorTypeState();

}
class _DoctorTypeState extends State<DoctorType> {
  List listItem=[];
  var rout;
  Future consreq() async {
    CollectionReference ref= await Firestore.instance.collection('/Hospitals/'+widget.Id+'/Specialty').getDocuments().then((v){
      v.documents.forEach((element) {
        listItem.add(element.documentID.toString());
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
    print(listItem.length);
    print(widget.Id);
    return Scaffold(appBar: AppBar(title: Text(widget.title),),
    body: GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, i) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
            child: GestureDetector(
              onTap: () {
    Navigator.push(context, MaterialPageRoute(builder: (con){
    return ChooseDoctor(widget.Id, listItem[i],widget.Pid);}));
              },
              child:FittedBox(
                fit: BoxFit.fill,
                child: Image.asset(
                  'image/048-doctor.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            footer: GridTileBar(
              title: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  listItem[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13),
                ),
              ),
              backgroundColor: Colors.black26,
            ),
      ));
    },itemCount: listItem.length,)

   );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_medicine1/doctor/me\dicine_data.dart';
class AddNewMedicine extends StatefulWidget{
  final List _MedicineD;
  AddNewMedicine( this._MedicineD);


  @override
  _AddNewMedicineState createState() => _AddNewMedicineState();
}

class _AddNewMedicineState extends State<AddNewMedicine> {
  String _SMedicine='';
  String _amount='';
  int _Quantity=0;
  String _MedicineType='';
  double Dose=1;
  double value = 0.0;

  Widget MedicineTimePday(){
    List<String>Items=['1','2','3','4'];
    return Column(        crossAxisAlignment: CrossAxisAlignment.start,children: [
           Container(margin: EdgeInsets.only(top: 4),
            child: DropDownField(
              itemsVisibleInDropdown: 5,
              value:_amount,
              required: true,
              items:Items,
              hintText: 'Choose the Amount',
              onValueChanged: (val){
                setState(() {
                  _amount=val;
                });
              },
              icon: Icon(Icons.medical_services,color: Colors.green,),
            ),
          ),
    ],);



  }
  Widget Medicine(){
    String _Medicine='';
    return ListView( children: [
    StreamBuilder(stream:Firestore.instance.collection('/Hospitals/AlnoorHospital /pharmacy')
        .where('Quantity',isGreaterThan: 0).snapshots(),builder: (ctx,snapshot){
    List<String>Items=[];
    if(snapshot.hasData){
    snapshot.data.documents.map((val){
    Items.add(val['MedicineName']);
    }).toList();
    if(snapshot.data.documents.length!=Items.length){
    setState(() {
    Items.clear();
    });
    }
    return Container(margin: EdgeInsets.only(top: 4),
    child: DropDownField(
    itemsVisibleInDropdown: 5,
    value:_Medicine,
    required: true,
    items:Items,
    hintText: 'Add Medicine',
      onValueChanged: (val){
      setState(() {
        _Medicine=val;
        _SMedicine=_Medicine;
      });
      },
    icon: Icon(Icons.medical_services,color: Colors.green,),
    ),
    );
    }
    if(snapshot.connectionState==ConnectionState.waiting){
    return Center(child: CircularProgressIndicator());
    }
    return Center(child: CircularProgressIndicator());

    }),
    _SMedicine.isNotEmpty?MedicineTimePday():Container(),
    _SMedicine.isNotEmpty?Med(_SMedicine):Container(),
    _MedicineType=='syrup'?Slider(divisions: 60,label: value.toString(),
   min: 0.0,max: 15.0,value: value, onChanged:(val)=>setState(()=>this.value=val)):Container(),
    ],);

  }
  Widget Med(String _Medicine){
    return StreamBuilder(stream: Firestore.instance.collection('/Hospitals/AlnoorHospital /pharmacy').document(_Medicine).
    snapshots(),builder: (ctx,MedicineD){
      if(MedicineD.hasData){
        _Quantity=MedicineD.data['MedicineQuantity'];
        _MedicineType=MedicineD.data['MedicineType'];
        return Card(elevation: 5,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
            Container(margin: EdgeInsets.only(top: 10,left: 5),width: MediaQuery.of(context).size.width*0.45,
         child: Text('Medicine : '+MedicineD.data['MedicineName'],style: TextStyle(fontWeight: FontWeight.w300),)),
            Container(margin: EdgeInsets.only(top: 10,left: 5),width: MediaQuery.of(context).size.width*0.30,
         child:Text('Quantity: '+MedicineD.data['MedicineQuantity'].toString(),style: TextStyle(fontWeight: FontWeight.w300))),
            Container(margin: EdgeInsets.only(top: 10,left: 5),width: MediaQuery.of(context).size.width*0.25,
         child:Text("Type: "+MedicineD.data['MedicineType'],style: TextStyle(fontWeight: FontWeight.w300))),
            Container(margin: EdgeInsets.only(top: 10,left: 5),width: MediaQuery.of(context).size.width*0.90,
          child:Text(_MedicineType!='syrup'?"Dose: $Dose":'Dose: '+value.toString()+'ml',
              style: TextStyle(fontWeight: FontWeight.w300))),

          ],),
        );


      }
      if(MedicineD.connectionState==ConnectionState.waiting){
        return Center(child: CircularProgressIndicator());
      }
      return Center(child: CircularProgressIndicator());


    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:Medicine(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(_MedicineType=='syrup')
            Dose=value;
          final NewMedicneAdd=MedicineData(MedicineName: _SMedicine, amount: int.parse(_amount),
              Quantity: _Quantity, MedicineType: _MedicineType, Dose: Dose, dateTime: DateTime.now());
          setState(() {
            widget._MedicineD.add(NewMedicneAdd);
            Navigator.of(context).pop();
          });
          },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),

    );

  }
}
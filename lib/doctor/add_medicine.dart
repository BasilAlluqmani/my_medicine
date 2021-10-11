import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_medicine1/doctor/medicine_data.dart';
import 'package:my_medicine1/doctor/test2.dart';
import 'package:my_medicine1/doctor/add_new_medicine.dart';

class AddMedicine extends StatefulWidget {
  @override
  _AddMedicineState createState() => _AddMedicineState();
}

List<MedicineData> _MedicineL = [];
List MEDId = [
];


class _AddMedicineState extends State<AddMedicine> {
 Future CancelMedicine(String hospital,String PID,int i,String Medicine)async{
   var Q=0;
   await Firestore.instance.collection('/Hospitals/${hospital}/pharmacy').document(Medicine).get().then((value) =>Q=value.data['Quantity']+1);
   await Firestore.instance.collection('/Hospitals/${hospital}/pharmacy').document(Medicine).updateData({
     'Quantity':Q
   });
   await Firestore.instance.collection('Patient').document(PID).collection('Patient_records').document(MEDId[i]).delete();

 }
  String _SMedicine='';
  String _amount='';
  int _Quantity=0;
  String _MedicineType='';
  double Dose=1;
  double value = 0.0;
 var gr=1;

  Widget MedicineTimePday(){
    List<String>Items=['1','2','3','4'];
    return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
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
  String _Medicine='';
  Widget Medicine(String hospital,String PID){
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
      CarouselSlider(items: _MedicineL.map((i) {
        var index = _MedicineL.indexOf(i);
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(onTap: ()=>showDialog(context: context, builder: (context) {
              return AlertDialog(
                title: Text('delete Medicine'),
                content: Text('Are you sure you want to delete ${i.MedicineName} medicine  ?'), actions: [
                MaterialButton(color: Colors.red, onPressed: () {Navigator.of(context).pop();
                },
                  child: Text('No', style: TextStyle(color: Colors.white),),
                ),
                MaterialButton(color: Colors.green, onPressed: () {
                  CancelMedicine(hospital,PID,index,_MedicineL[index].MedicineName);
                  _MedicineL[index].MedicineName;
                  _MedicineL.removeAt(index);
                  Navigator.of(context).pop();
                },
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              );
            }),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.grey),borderRadius:BorderRadius.all(Radius.circular(10)),

                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Container(width: double.infinity,decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))),child:Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text((index+1).toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)],)),
                    Container(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01,top: MediaQuery.of(context).size.height*0.001),width: MediaQuery.of(context).size.width*0.7,child: Text('Medicine : ${i.MedicineName}', style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.w300),)),
                    Container(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01,top: MediaQuery.of(context).size.height*0.001),width: MediaQuery.of(context).size.width*0.7,child: Text('Medicine Type : ${i.MedicineType}', style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.w300),)),
                    Container(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01,top: MediaQuery.of(context).size.height*0.001),width: MediaQuery.of(context).size.width*0.7,child: Text(i.MedicineType=='pills'?'Dose: ' +i.Dose.toString():'Dose: ' +i.Dose.toString()+ ' ml', style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.w300),)),
                    Container(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01,top: MediaQuery.of(context).size.height*0.001),width: MediaQuery.of(context).size.width*0.7,child: Text('Daily Dose : ${i.amount.toString()}', style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.w300),)),
                    Container(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01,top: MediaQuery.of(context).size.height*0.001),width: MediaQuery.of(context).size.width*0.7,child: Text( i.MedicineType=='pills'?'Quantity: ' +i.Quantity.toString(): 'Quantity: ' +i.Quantity.toString()+" ml", style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.w300),)),
                    Container(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01,top: MediaQuery.of(context).size.height*0.001),width: MediaQuery.of(context).size.width*0.7,child: Text('Added Time : ${DateFormat('yyyy-MM-dd-hh-mm').format(i.dateTime)}', style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.w300),)),
                  ],),

              ),
            );
          },
        );
      }).toList(),options: CarouselOptions(height: MediaQuery.of(context).size.height * 0.20,
        aspectRatio: 16/9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,),
       ),

    ],
    );


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
            Row(mainAxisAlignment: MainAxisAlignment.center,

              children: [Radio(activeColor: Colors.green,value: 1, groupValue: gr, onChanged: (val) {setState(() {gr = 1;});},),
                Text('Receive', style: new TextStyle(fontSize: 17.0),),

                Radio(activeColor: Colors.green,value: 2, groupValue: gr, onChanged: (val) {setState(() {gr = 2;});}),
                Text('Delivery', style: new TextStyle(fontSize: 17.0,)),
              ],),

          ],),

        );

      }
      if(MedicineD.connectionState==ConnectionState.waiting){
        return Center(child: CircularProgressIndicator());
      }
      return Center(child: CircularProgressIndicator());


    });
  }
  String Da(Timestamp date) {
    final Timestamp timestamp = date as Timestamp;
    DateTime d = timestamp.toDate();
    String s = '';
    s = DateFormat('yyyy-MM-dd-hh-mm').format(d);
    return s;
  }
  void _startAddNewMedicine() {
    Navigator.push(context, MaterialPageRoute(builder: (con){
      return AddNewMedicine(_MedicineL);
    }));
  }


  @override
  Widget build(BuildContext context) {
    final route =
    ModalRoute.of(context).settings.arguments as Map<String,Object> ;
    Future UpdateMedicine(String Medicine,_Quantity,_MedicineType,Dose,_amount)async{
      String MID=DateTime.now().millisecondsSinceEpoch.toString();
      Random random = new Random();
      int code = random.nextInt(10000);
      int Q=0;
     await Firestore.instance.collection('/Hospitals/${route['hospital']}/pharmacy').document(Medicine).get().then((value) =>Q=value.data['Quantity']-1);
     await Firestore.instance.collection('/Hospitals/${route['hospital']}/pharmacy').document(Medicine).updateData({
       'Quantity':Q
     });
     await Firestore.instance.collection('Patient').document(route['PID']).collection('Patient_records').document(MID+Medicine).setData(gr==1?{
        'MedicineName':Medicine,
        'MedicineQuantity':_Quantity,
        'MedicineType':_MedicineType,
        'Date':DateTime.now(),
        'Doctor':route['Id'],
       'hospaital':route['hospital'],
       'Done':false,
        'Dose':Dose,
        'DallyDose':int.parse(_amount),
        "DeliveryType":'Receive'
      }:{
       'MedicineName':Medicine,
       'MedicineQuantity':_Quantity,
       'MedicineType':_MedicineType,
       'Date':DateTime.now(),
       'Doctor':route['Id'],
       'hospaital':route['hospital'],
       'Done':false,
       'Dose':Dose,
       'code':code,
       'DallyDose':int.parse(_amount),
       'state':false,
       "DeliveryType":'Deliver'
     }).whenComplete(() => MEDId.add(MID+Medicine));
    }

    return Scaffold(
      
      appBar: AppBar(
        title: Text('Add Medicine'),
        actions: [
          IconButton(
              icon: Icon(Icons.add_box_outlined),
              onPressed: () {
                if(_MedicineType=='syrup')
                  Dose=value;
                if(_amount.isNotEmpty&&_SMedicine.isNotEmpty){
                  final NewMedicneAdd=MedicineData(MedicineName: _SMedicine, amount: int.parse(_amount),
                      Quantity: _Quantity, MedicineType: _MedicineType, Dose: Dose, dateTime: DateTime.now());
                  setState(() {
                    UpdateMedicine(_SMedicine,_Quantity,_MedicineType,Dose,_amount);
                    _MedicineL.add(NewMedicneAdd);
                    _SMedicine='';_Medicine='';Dose=1;_amount='';_MedicineType='';

                  });
                }
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Container(
                width: MediaQuery.of(context).size.width * 0.50,
                margin: EdgeInsets.only(left: 5, top: 5, bottom: 10),
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text('Name: '+route['Name']))),Container(
                width: MediaQuery.of(context).size.width * 0.30,
                margin: EdgeInsets.only(left: 5, top: 5, bottom: 10),
                    child: Text("Age: "+route['Age'].toString())),],),
              Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.70,
              child: Card(
                elevation: 5,
                child: Medicine(route['hospital'],route['PID']),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center,children: [Container(margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.035),child:_MedicineL.isNotEmpty? RaisedButton(onPressed: (){
              _MedicineL.clear();
              Navigator.of(context)
                  .pushReplacementNamed('PDoctor', arguments: {'ID':route['Id'],'Hospital':route['hospital'],'Specialty':route['Sph']});
            },color: Colors.green,child: Text('Add Precption',style: TextStyle(color: Colors.white),),):Container()),
            ],),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.list_alt),
        backgroundColor: Colors.green,
      ),

    );
  }

}
/*
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
width: MediaQuery.of(context).size.width * 0.45,
margin: EdgeInsets.only(left: 5, top: 5, bottom: 10),
child: FittedBox(
fit: BoxFit.fitWidth,
child: Text(
"Medicine Added",
style: TextStyle(color: Colors.green),
))),
Expanded(
child: Container(
width: double.infinity,
decoration: BoxDecoration(
border: Border.all(color: Colors.grey[300])),
child: ListView.builder(
itemCount: _MedicineL.length,
itemBuilder: (ctx, i) {
return Card(
child: Row(
mainAxisAlignment: MainAxisAlignment.start,
children: [
Icon(Icons.medical_services_rounded, color: Colors.green,
size: MediaQuery.of(context).size.width * 0.17,
),
Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Row(
children: [
Container(width: MediaQuery.of(context).size.width*0.5,
margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.10,),
child: Text(_MedicineL[i].MedicineName,style: TextStyle(fontSize: 12),),
),
],
),
Row(children: [Container(width: MediaQuery.of(context).size.width*0.18,
margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.06),
child: FittedBox(fit: BoxFit.fitWidth,child: Text('Type: ' + _MedicineL[i].MedicineType)),
),Container(width: MediaQuery.of(context).size.width*0.18,
margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.02),
child: FittedBox(fit: BoxFit.fitWidth,
child: Text(_MedicineL[i].MedicineType=='pills'?'Dose: ' +_MedicineL[i].Dose.toString()
    :'Dose: ' +_MedicineL[i].Dose.toString()+" ml")),
),Container(width: MediaQuery.of(context).size.width*0.17,
margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.02,
), child: FittedBox(fit:BoxFit.fitWidth,
child: Text( _MedicineL[i].MedicineType=='pills'?'Quantity: ' +_MedicineL[i].Quantity.toString():
'Quantity: ' +_MedicineL[i].Quantity.toString()+" ml"),
),
),
IconButton(iconSize: MediaQuery.of(context).size.width*0.10,
icon: Icon(Icons.restore_from_trash_rounded,color: Colors.red,), onPressed:(){setState(() {
_MedicineL.removeAt(i);
});}),],),
Row(children: [
Container(width: MediaQuery.of(context).size.width*0.3,child: FittedBox(fit:BoxFit.fitWidth,child: Text(DateFormat('yyyy-MM-dd-hh-mm').format(_MedicineL[i].dateTime)))),
Container(margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03),width: MediaQuery.of(context).size.width*0.22,child: FittedBox(fit:BoxFit.fitWidth,child: Text('Daily dose:  '+_MedicineL[i].amount.toString()))),
],),
],
)
],
),
);
})),
)
],
),*/

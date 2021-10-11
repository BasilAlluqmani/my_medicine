import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Deliver extends StatefulWidget{
  String id;
  Deliver(this.id);

  @override
  _DeliverState createState() => _DeliverState();
}

class _DeliverState extends State<Deliver> {
  var _formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    var Code='';
    String Da(Timestamp date) {
      final Timestamp timestamp = date as Timestamp;
      DateTime d = timestamp.toDate();
      String s = '';
      s = DateFormat('yyyy-MM-dd-hh-mm').format(d);
      return s;
    }
    return Scaffold(
      body: StreamBuilder(stream: Firestore.instance.collection('/Patient/${widget.id}/Patient_records').where('Done',isEqualTo: true).where('state',isEqualTo: false).where('DeliveryType',isEqualTo: 'Deliver').snapshots(),builder: (ctx,s){
        if(s.hasData){
          return ListView.builder(itemCount: s.data.documents.length,itemBuilder:(ctx,i){
            double f=(s.data.documents[i]['MedicineQuantity']/(s.data.documents[i]['Dose']*s.data.documents[i]['DallyDose']));
            return Container(color: Colors.grey,width: double.infinity,child: Card(child: Row(children: [

                  Container(margin: EdgeInsets.only(left: 5),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [Container(margin: EdgeInsets.only(top:3),child: Text(s.data.documents[i]['MedicineName'],style: TextStyle(fontWeight: FontWeight.w300),)),Container(margin: EdgeInsets.only(top:3,bottom: 3),child: Row(children: [Container(width: MediaQuery.of(context).size.width*0.35,child: Text('Dally Dose :'+s.data.documents[i]['DallyDose'].toString(),style: TextStyle(fontWeight: FontWeight.w300))),Text('Dose :'+s.data.documents[i]['Dose'].toString(),style: TextStyle(fontWeight: FontWeight.w300)),])),
                      Container(margin: EdgeInsets.only(bottom: 3),child: Row(children: [Container(width: MediaQuery.of(context).size.width*0.35,child: Text('Type :'+s.data.documents[i]['MedicineType'],style: TextStyle(fontWeight: FontWeight.w300))),Text('Quantity :'+s.data.documents[i]['MedicineQuantity'].toString(),style: TextStyle(fontWeight: FontWeight.w300))],)),
                      Container(width: MediaQuery.of(context).size.width*0.7,margin: EdgeInsets.only(bottom: 3),child: Text('Date :'+Da(s.data.documents[i]['Date'],),style: TextStyle(fontWeight: FontWeight.w300))),
                      Form(key: _formKey,
                        child:Row(children: [Container(width:MediaQuery.of(context).size.width*0.3,child: TextFormField(decoration: InputDecoration(
                            labelText: "Enter Code"), validator: (val) {
                          if (val.isEmpty || val.length !=4||val!=s.data.documents[i]['code'].toString()) {
                            return 'not valid';
                          }else return null;

                        },
                          onSaved: (val) {
                            Code = val;
                          }, maxLength: 4,),),IconButton(icon: Icon(Icons.assignment_turned_in_outlined,color: Colors.green,), onPressed: (){
                          final isValid = _formKey.currentState.validate();
                          FocusScope.of(context).unfocus();
                          _formKey.currentState.save();
                            setState(() {

                            if(isValid){
                              Firestore.instance.collection('/Patient/${widget.id}/Patient_records').document(s.data.documents[i].documentID).updateData(
                                  {'state':true,'ExpiryDate':DateTime.now().add(Duration(days: f.ceil()))});
                             }
                          });
                        }),]),
            )],),
                  ),
                 ],)));
          });
        }else
          return Container();
      },));
  }
}
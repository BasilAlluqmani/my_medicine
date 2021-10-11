import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DrList1 extends StatefulWidget{
  String value1;
  String value2;
  DrList1(this.value1,this.value2);

  @override
  _DrList1State createState() => _DrList1State();
}

class _DrList1State extends State<DrList1> {
  @override
  Widget build(BuildContext context) {
    Firestore.instance
        .collection('users').getDocuments()
        .then((QuerySnapshot querySnapshot) => {
    querySnapshot.documents.forEach((doc) {
    print(doc["first_name"]);
    })
    });
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.5,
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('/Hospitals/'+widget.value1+' /Doctor/Specialty/'+widget.value2)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          var doc = snapshot.data.documents;
          return ListView.builder(
              itemBuilder: (ctx, index) {
                return Container( margin: EdgeInsets.only(left: 5,right: 5),decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.17,
                  child: Card(
                    elevation: 5,
                    child: Column(children: [
                      Container(margin: EdgeInsets.only(left: 10,top: 10),
                        child: Row(children: [
                          Container(width: MediaQuery.of(context).size.width*0.4,child: Text('Dr: '+doc[index]['Fname']+' '+doc[index]['Lname'],style: TextStyle(fontSize: 17,fontWeight: FontWeight.w300),)),

                        ],),
                      ),
                      Container(margin: EdgeInsets.only(left: 10,top: 10),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                          Container(width: MediaQuery.of(context).size.width*0.35,child: Text(doc[index]['Nationality'],style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),)),
                          Container(width: MediaQuery.of(context).size.width*0.2,child: Text('Age: '+'29',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),)),
                          Container(width: MediaQuery.of(context).size.width*0.35,child: Text(doc[index]['specialty'],style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),)),

                        ],),
                      ),
                      Row(children: [
                        Container(margin: EdgeInsets.only(left: 10,top: 10),width: MediaQuery.of(context).size.width*0.33,child: Text('Experience:  '+'20',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),)),
                        Container(margin: EdgeInsets.only(left: 10,top: 10),width: MediaQuery.of(context).size.width*0.3,child: Text('Sex:  '+doc[index]['Sex'],style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),)),
                        IconButton(icon: Icon(Icons.post_add_sharp), onPressed: (){


                        },color: Colors.green,)


                      ],),

                    ],),
                  ),
                );
              },
              itemCount: snapshot.data.documents.length);
        },
      ),
    );


  }

}

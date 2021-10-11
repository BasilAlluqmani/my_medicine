import 'package:flutter/material.dart';
import 'package:my_medicine1/patient_screens/current_m.dart';
import 'package:my_medicine1/patient_screens/previous_m.dart';
import 'package:my_medicine1/patient_screens/Deliver_m.dart';
class Medicine extends StatefulWidget {
  String id;
  Medicine(this.id);

  @override
  _MedicineState createState() => _MedicineState();
}

class _MedicineState extends State<Medicine> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text:"Current",),
              Tab(text: 'Pervious',),
              Tab(text:'Deliver'),
            ],
          ),
          title: Text('Medicine'),automaticallyImplyLeading: false
        ),
        body: TabBarView(
          children: [
           Current(widget.id),
            Pervious(widget.id),
            Deliver(widget.id),

          ],
        ),
      ),
    );

  }
}
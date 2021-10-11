import 'package:flutter/material.dart';
import 'package:my_medicine1/screens/sign_in.dart';
import 'package:my_medicine1/screens/doctor_signin.dart';
import 'package:my_medicine1/screens/phar_signin.dart';
class TabBarS extends StatefulWidget {
  @override
  _TabBarSState createState() => _TabBarSState();
}

class _TabBarSState extends State<TabBarS> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text:"Patient",),
                Tab(text: 'Doctor',),
                Tab(text:'Pharmacist'),
              ],
            ),
            title: Text('Sign In'),automaticallyImplyLeading: false
          ),
          body: TabBarView(
            children: [
              SignIn(),
              SignInDoc(),
              SignInPha(),
            ],
          ),
        ),
      );

  }
}
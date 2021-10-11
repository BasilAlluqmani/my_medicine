import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_medicine1/patient_screens/screens.dart';
import 'package:intl/intl.dart';




class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  String _fname='';

  String _lname='';

  DateTime _d=DateTime.now();

  String _Nat='';

  String _phone='';
  String _male='';

  String _email='';
  String age='';
  final formKey =GlobalKey<FormState>();
  String ID='';
  String Passw='';

  final contText1 = TextEditingController();
  final contText2 = TextEditingController();
  void submit(){
    final isValid =formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if(isValid){
      formKey.currentState.save();
      print(ID);
      print(Passw);
      DocumentReference ref=Firestore.instance.collection('Patient').document(ID);
      ref.get().then((v){
        if(ID==v.data['id'].toString()){
          print('log');
            if(Passw==v.data['password']){
              print('LogIn');
              _fname=v.data['name'];
              _Nat=v.data['Nationality'];
              _phone=v.data['phone'];
              _email=v.data['email'];
              _male=v.data['sex'];
              final Timestamp timestamp = v.data['Date'] as Timestamp;
              _d = timestamp.toDate();
              String s='';
              s=DateFormat('yyyy-MM-dd').format(_d);
              DateTime nd = DateTime.parse(s);
              Duration dur =  DateTime.now().difference(nd);
              String difference = (dur.inDays/365).floor().toString();
              age=difference;
              Navigator.of(context).pushReplacementNamed('PFirt',arguments:v.data['id']);

            }
            else print('Wrong Password');
        }
        else print('No Id regstier');
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
      body: Container(
          child: ListView(
            children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(100)),
                      gradient: LinearGradient(
                          colors: [Colors.green, Colors.greenAccent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter)),
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Center(
                    child: CircleAvatar(
                      backgroundImage: AssetImage('image/logo.png'),
                      radius: 90,
                    ),
                  ),
                ),
                 Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.perm_identity_outlined),
                                  labelText: "Enter ID Number"),
                              validator: (val){
                                if(val.isEmpty||val.length!=10){
                                   return 'plase enter valid id';
                                }
                                return null;

                              },
                              onSaved: (val){
                                ID=val;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock_outline_rounded),
                                  labelText: "Enter Password"),
                              obscureText: true,
                              validator: (val){
                                if(val.isEmpty||val.length<8){
                                  return 'Password must be at least 8 charcter';
                                }
                                return null;
                              },
                              onSaved: (val){
                                Passw=val;
                              },
                            ),

                          ],
                        ),
                      ),
                        SizedBox(
                      width: double.infinity,
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.035),
                        child: RaisedButton(
                          onPressed: submit,
                          child: Text('Sign In'),
                          color: Colors.green,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.035),
                        child: RaisedButton(
                          onPressed: (){
                            Navigator.of(context).pushNamed('SignUp');
                          },
                          child: Text('Sign up'),
                          color: Colors.green,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(15))),
                        ),
                      ),
                    ),


                  ],
                ),
              )
            ],
          ),

      ),
    );
  }
}

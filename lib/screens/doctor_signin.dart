import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_medicine1/patient_screens/screens.dart';

class SignInDoc extends StatefulWidget {
  @override
  _SignInDocState createState() => _SignInDocState();
}

class _SignInDocState extends State<SignInDoc> {
  final formKey = GlobalKey<FormState>();
  String ID = '';
  String Passw = '';

  final contText1 = TextEditingController();
  final contText2 = TextEditingController();
  void submit() {
    final isValid = formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      formKey.currentState.save();
      print(ID);
      print(Passw);
      Firestore.instance.collection('Hospitals').getDocuments().then((v) {
        v.documents.forEach((element) {
          Firestore.instance
              .collection('Hospitals')
              .document(element.documentID)
              .collection('Specialty')
              .getDocuments()
              .then((value) => value.documents.forEach((element2) {
                    Firestore.instance
                        .collection('Hospitals')
                        .document(element.documentID)
                        .collection('Specialty')
                        .document(element2.documentID)
                        .collection('ID')
                        .document(ID)
                        .get()
                        .then((dataDr) {
                      if (dataDr.exists) {
                        if (ID == dataDr.data['id'].toString()) {
                          print('log');
                          if (Passw == dataDr.data['password']) {
                            print('LogIn');
                            Navigator.of(context)
                                .pushReplacementNamed('PDoctor', arguments: {'ID':ID,'Hospital':element.documentID,'Specialty':element2.documentID});
                          } else
                            print('Wrong Pass');
                        } else
                          print('No Id regstier');
                      }
                      ;
                    });
                  }));
        });
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
                          validator: (val) {
                            if (val.isEmpty || val.length != 8) {
                              return 'plase enter valid id';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            ID = val;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline_rounded),
                              labelText: "Enter Password"),
                          obscureText: true,
                          validator: (val) {
                            if (val.isEmpty || val.length < 8) {
                              return 'Password must be at least 8 charcter';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            Passw = val;
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:my_medicine1/screens/sign_in.dart';
class Create_account extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Create_account> {
  final _formKey =GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm_password = TextEditingController();
  bool isHiddenPassword=true;
  bool isHeddenPassword2=true;
  TextEditingController _iduser=TextEditingController();
  var perReductionController=TextEditingController();

  String userName;
  String nationality;
  String sex;
  String phone;
  String city;
  Timestamp date;



  @override
  void dispose() {
    _iduser.dispose();
    perReductionController.dispose();
    super.dispose();
  }


  //يتحقق اذا كان id موجود في ابشر او لا
  Search_in_Absher() {

    DocumentReference documentReference = Firestore.instance.
    collection("Absher").document(_iduser.text);

    documentReference.get().then((datasnapshot) {
      if (datasnapshot.data!=null) {
        userName= datasnapshot['name'];
        date=datasnapshot['Date'];
        nationality=datasnapshot['Nationality'];
        city=datasnapshot['city'];
        phone=datasnapshot['phone'];
        sex=datasnapshot['sex'];

        Account_verification();

      } else {
        _error_alert(context,"This user is not registered in Absher ");
      }

    });}



  //يتحقق اذا عنده حساب او لا
  Account_verification() {
    

    Firestore.instance.collection('Patient').where('id',isEqualTo:_iduser.text).getDocuments().then((datasnapshot) {
      if(datasnapshot.documents.length==0){
        Create_account();
      }else{
        _error_alert(context,"This user has a registered account ");
      }
    }
    );
  }

  //ينشاء الحساب
  Create_account(){
    DocumentReference documentReference =
    Firestore.instance.
    collection("Patient").document(_iduser.text);
    Map<String, dynamic> Patient = {
      "email": _email.text,
      "password": _password.text,
      "id": _iduser.text,
      "name":userName,
      "Date":date,
      "Nationality":nationality,
      "city":city,
      "phone":phone,
      "sex":sex,
    };
    documentReference.setData(Patient).whenComplete(() {

      Navigator.of(context)
          .pushNamedAndRemoveUntil('Tap', (Route<dynamic> route) => false);
    });
  }






  Future _error_alert(BuildContext context, notfoundUser) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Icon(
            Icons.error_outline,
            size: 69, color: Colors.red,),
          content:  Text(notfoundUser,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
          actions: [
            FlatButton(
              child: Text('Ok',style: TextStyle(fontSize: 20.0),),
              onPressed: () {
                Navigator.of(context).pop();
                //  _iduser.clear();
              },
            ),
          ],
        );
      },
    );
  }





  List<Widget> image() {
    AssetImage image = new AssetImage('images/logo2.jpeg');
    Image myImg = new Image(
      image: image,
      height: 200, width: 400,);
    return [
      Container(
        height: 50,
        child: myImg,
      )
    ];
  }



  //All TextFormField ist here
  List<Widget> newText() {
    return[

      Form(

        key: _formKey,
        child: Column(

          children: <Widget>[
            SizedBox(height: 20,),

            TextFormField(

              keyboardType: TextInputType.number,
              maxLength: 10,
              maxLengthEnforced: true,
              controller: _iduser,
              validator: (String value){
                if(value.isEmpty){
                  return 'This Textfiled is Empty';
                }else if(value.length!=10){
                  return 'must be 10 number';
                }
                return null;
              },

              decoration: InputDecoration(
                //labelText: 'user id',

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),

                prefixIcon: Icon(Icons.perm_identity_rounded),

                hintText: 'Enter ID Number',

              ),


            ),


            SizedBox(height: 22.0,),

            TextFormField(

              keyboardType: TextInputType.emailAddress,
              controller: _email,
              validator: (String value){
                if(value.isEmpty){
                  return 'This Textfiled is Empty';
                }else if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                  return 'Please a valid Email';
                }
                return null;
              },
              decoration: InputDecoration(

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),

                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: "Enter Your Email"
              ),
            ),


            SizedBox(height: 22.0,),


            TextFormField(
              obscureText:isHiddenPassword,
              controller: _password,
              validator: (String value){
                if(value.isEmpty){
                  return 'This Textfiled is Empty';
                }else if (value.length < 8)
                {
                  return 'at least 8 Characters or number ';
                }else if(!RegExp( r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(value)) {
                  return 'Password must contain at least a lowercase letter and an upper case letter';
                }
                return null;
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),

                  prefixIcon: Icon(Icons.lock_outline),


                  suffixIcon:InkWell(
                      onTap: _togglePasswordView,
                      child: Icon(Icons.visibility)),

                  hintText: "Password"


              ),
            ),


            SizedBox(height: 22.0,),



            TextFormField(
              obscureText: isHeddenPassword2,
              controller: _confirm_password,
              validator: (String value){

                if(value.isEmpty){
                  return 'This Textfiled is Empty';
                } else if(value !=_password.value.text){
                  return 'password do not match';
                }else if (value.length < 8) {
                  return 'at least 8 Characters or number ';
                }else if(!RegExp( r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(value)) {
                  return 'Password must contain at least a lowercase letter and an upper case letter';
                }
                return null;
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),

                  prefixIcon: Icon(Icons.lock_outline),

                  suffixIcon:InkWell(
                      onTap: _togglePasswordView2,
                      child: Icon(Icons.visibility)),

                  hintText: 'Confirm password'

              ),

            ),



            SizedBox(height: 22.0,),


          ],


        ),
      )

    ];
  }


  //زر انشاء الحساب
  List<Widget> create_account_buttons() {
    return [
      RaisedButton(
        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(20),),
        child: Text('Create Account',
          style: TextStyle(fontSize: 20.0),
        ),

        textColor: Colors.white,
        color: Colors.green,
        onPressed: (){
          if(_formKey.currentState.validate()){

            Search_in_Absher();
          }

        },

      ),

      SizedBox(height: 20,),
      FlatButton(

        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(18.0),


        ),
        textColor: Colors.green,
        padding: EdgeInsets.all(8.0),

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignIn()),);
        },
        child: Text(
          "Do you have account ?",
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Create account"),
        backgroundColor: Colors.green,

      ),
      body:SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: image()+ newText() + create_account_buttons(),
            ),

          ),
        ),
      ),
    );
  }


  void _togglePasswordView() {

    setState(() {
      isHiddenPassword=!isHiddenPassword;
    });

  }
  void _togglePasswordView2() {

    setState(() {
      isHeddenPassword2=!isHeddenPassword2;
    });

  }

}



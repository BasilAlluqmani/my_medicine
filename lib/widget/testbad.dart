
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_medicine1/screens/tab_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class settings extends StatefulWidget {
  @override
  _settingsState createState() => _settingsState();
}

class _settingsState extends State<settings> {
  TextEditingController _numberCtrl = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  int selected_Delivery_type;
  int id=1;
  final _formKey =GlobalKey<FormState>();
  final _old_password = TextEditingController();
  final _new_password = TextEditingController();
  final _Confirm_new_password = TextEditingController();

  var password_Patient;

  bool isHiddenPassword=true;
  bool isHeddenPassword2=true;
  bool isHiddenPassword3=true;


  @override
  Widget build(BuildContext context) {
    final id =
    ModalRoute.of(context).settings.arguments as String ;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Settings"),),


      body:Container(
        height: double.infinity, color: Colors.white10,

        child: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(8.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Account settings",style: TextStyle(fontSize: 32.0),), const SizedBox(height: 10.0),

                Card(
                  elevation: 4.0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),

                  child: Column(children: <Widget>[

                    ListTile(leading: Icon(Icons.lock_outline, color: Colors.green,),
                        title: Text("Change password",style: TextStyle(fontSize: 22.0),),
                        trailing: Icon(Icons.keyboard_arrow_right), onTap: () {Change_password(id);}),

                    Container(margin: const EdgeInsets.symmetric(horizontal: 8.0), width: double.infinity,
                      height: 1.0, color: Colors.grey.shade400,),

                    ListTile(
                        leading: Icon(Icons.language, color: Colors.green,),
                        title: Text("Change language",style: TextStyle(fontSize: 22.0),),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          change_language(context);
                        }),


                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      width: double.infinity, height: 1.0,
                      color: Colors.grey.shade400,
                    ),


                  ],
                  ),
                ),

                const SizedBox(height: 50.0),


                Text("About Application",style: TextStyle(fontSize: 32.0),), const SizedBox(height: 10.0),
                Card(elevation: 4.0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),

                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.info_outline, color: Colors.green,),
                        title: Text("About as",style: TextStyle(fontSize: 22.0),),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: (){
                          about_as();

                        },
                      ),

                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        width: double.infinity, height: 1.0, color: Colors.grey.shade400,),

                      ListTile(
                        leading: Icon(Icons.message_outlined, color: Colors.green,),
                        title:  Text("Connect US",style: TextStyle(fontSize: 22.0),),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => {
                          Connect_US(context)
                        },
                      ),

                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        width: double.infinity, height: 1.0, color: Colors.grey.shade400,
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 20.0),

                FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),

                  minWidth: double.infinity,
                  onPressed: (){
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('Tap', (Route<dynamic> route) => false);
                  },
                  child: Text("Logout", style: TextStyle(color: Colors.white,fontSize: 32.0),),
                  color: Colors.red,
                ),

              ],
            ),
          ),
        ),
      ),

    );
  }


  //هنا تغير كلمة المرور  ((((غير اسم الكوليكشن))))
  void Change_password(String id){
    DocumentReference documentReference=
   Firestore.instance.
    collection("Patient").document(id);
    documentReference.get().then((datasnapshot){
      password_Patient=datasnapshot.data["password"];
    });

    showModalBottomSheet(
        enableDrag: false, isDismissible: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(24),
          topRight: Radius.circular(24),),), barrierColor: Colors.black.withOpacity(0.20),

        context: context, builder: (context){
      return Scaffold(

        body: SingleChildScrollView(

          child: Container(

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: <Widget>[
                Form(

                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20,),

                        TextFormField(
                          obscureText:isHiddenPassword,
                          controller: _old_password,
                          validator: (String value){
                            if(value.isEmpty){
                              return 'This Textfiled is Empty';
                            }else if (value.length < 8) {
                              return 'at least 6 Characters or number ';
                            }else if(value!=password_Patient){
                              return 'كلمة المرور القديمة خطأ';
                            }else if(!RegExp( r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(value)) {
                              return 'Please a valid Password';
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
                          controller: _new_password,
                          validator: (String value){

                            if(value.isEmpty){
                              return 'This Textfiled is Empty';
                            } else if(value ==_old_password.value.text){
                              return 'نفس كلمة المرور القديمة';
                            }else if (value.length < 8) {
                              return 'at least 6 Characters or number ';
                            }else if(!RegExp( r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(value)) {
                              return 'Please a valid Password';
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
                              hintText: 'Your new password'

                          ),

                        ),



                        SizedBox(height: 22.0,),
                        TextFormField(
                          obscureText: isHiddenPassword3,
                          controller: _Confirm_new_password,
                          validator: (String value){

                            if(value.isEmpty){
                              return 'This Textfiled is Empty';
                            } else if(value !=_new_password.value.text){
                              return 'لا تتطابق كلمة المرور الجديدة مع تاكيد كلمة المرور';
                            }else if (value.length < 8) {
                              return 'at least 6 Characters or number ';
                            }else if(!RegExp( r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(value)) {
                              return 'Please a valid Password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),

                              prefixIcon: Icon(Icons.lock_outline),

                              suffixIcon:InkWell(
                                  onTap: _togglePasswordView3,
                                  child: Icon(Icons.visibility)),
                              hintText: 'Confirm Your new password'

                          ),

                        ),

                      ],
                    ),
                  ),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                  minWidth: double.infinity,
                  onPressed: (){
                    if(_formKey.currentState.validate()){
                      DocumentReference documentReference=
                      Firestore.instance.collection("Patient").document(id);
                      Map<String, dynamic> Change_password={"password":_new_password.text,};
                      documentReference.updateData(Change_password).whenComplete((){});

                      _old_password.clear();
                      _new_password.clear();
                      _Confirm_new_password.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Confirm", style: TextStyle(color: Colors.white,fontSize: 20),),
                  color: Colors.green,
                ),
              ],
            ),

          ),
        ),
      );
    }
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
  void _togglePasswordView3() {

    setState(() {
      isHiddenPassword3=!isHiddenPassword3;
    });

  }


  void call(command)async{
    if(await canLaunch(command) ){
      await launch(command);
    }else{
      print("Error$command");
    }
  }


  void Connect_US(context){
    showModalBottomSheet(
        enableDrag: true, isDismissible: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(24),
          topRight: Radius.circular(24),),), barrierColor: Colors.black.withOpacity(0.20),

        context: context, builder: (context){
      return Container(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(11.0),

          child:Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text("Call us",style: TextStyle(fontSize: 30),),   SizedBox(height: 3,),
              Card(elevation: 4.0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),

                child: Column(children: [
                  ListTile(leading: Icon(Icons.phone, color: Colors.green,),
                    title: Text("+966569861476 ",style: TextStyle(fontSize: 22),),
                    trailing: Icon(Icons.arrow_forward_ios_outlined),
                    onTap: (){call('tel:+966569861476');},),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey.shade400,
                  ),

                  ListTile(leading: Icon(Icons.sms, color: Colors.green,),
                    title: Text("+966569861476",style: TextStyle(fontSize: 22),),
                    trailing: Icon(Icons.arrow_forward_ios_outlined),
                    onTap: (){call('sms:+966569861476');},),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey.shade400,
                  ),

                  ListTile(leading: Icon(Icons.email_outlined, color: Colors.green,),
                    title: Text("mymedicine0008@gmail.com",style: TextStyle(fontSize: 18),),
                    trailing: Icon(Icons.arrow_forward_ios_outlined),
                    onTap: (){call('mailto:mymedicine0008@gmail.com?subject=y%20');},),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey.shade400,
                  ),


                ],
                ),)
            ],),
        ),
      );
    }
    );
  }



  void about_as(){
    showModalBottomSheet(

        enableDrag: false, isDismissible: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(24),
          topRight: Radius.circular(24),),), barrierColor: Colors.black.withOpacity(0.20),

        context: context, builder: (context){
      return SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("My Medicine It is an application that helps and facilitates for the doctor and the patient at the same time to take necessary medications and identify Dates of taking medicines and reminding the patient about them and alerting the patient when "
                      "the amount of medicine runs out and It is facilitates ""communication between the patient and the doctor and helps"" the doctor to know the current and previous medicines of the ""patient and facilitates for the patient to deliver the medicine to the home in case the medicine is running out of the patient or the doctor add a new medicine to the patient",
                    style: TextStyle(fontSize: 22.0),),

                  SizedBox(height: 10.0,),

                  FlatButton(
                    onPressed: (){

                      Navigator.pop(context);

                    },
                    child: Text("OK",style: TextStyle(color: Colors.white),),
                    color: Colors.green,
                    minWidth: double.infinity,
                  ),

                ],
              ),
            ),),
        ),
      );
    }
    );
  }


  void change_language(context){
    showModalBottomSheet(shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(24),
      topRight: Radius.circular(24),),), barrierColor: Colors.black.withOpacity(0.20),
        context: context, builder: (context){

          return Padding(padding: const EdgeInsets.all(8.0),

            child: Container(height: 150,  child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center,

                children: <Widget>[
                  SizedBox(height: 10,),


                  changelanguage(),


                  SizedBox(height: 10,),

                  FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                    onPressed: (){},
                    color: Colors.green, minWidth: double.infinity,
                    child: Text("Save",style: TextStyle(fontSize: 32,color: Colors.white),
                    ),

                  ),

                ],
              ),
            ),

            ),
          );
        }
    );
  }


}


class changelanguage extends StatefulWidget {
  @override
  _changelanguageState createState() => _changelanguageState();
}

class _changelanguageState extends State<changelanguage> {

  int id=1;


  void change_language(context){
    //changeSystemColor(Colors.pink);
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(24),
          topRight: Radius.circular(24),),), barrierColor: Colors.black.withOpacity(0.20),

        context: context, builder: (context){

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 150,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[SizedBox(height: 10,),
                Row(mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[Radio(value: 1, groupValue: id, onChanged: (val) {setState(() {id = 1;});},),
                    Text('Einglish', style: new TextStyle(fontSize: 17.0),),

                    Radio(value: 2, groupValue: id, onChanged: (val) {setState(() {id = 2;});}),
                    Text('عربي', style: new TextStyle(fontSize: 17.0,)),
                  ],),
                SizedBox(height: 10,),

                FlatButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),

                  onPressed: (){}, color: Colors.green, minWidth: double.infinity,
                  child: Text("Save",style: TextStyle(fontSize: 32,color: Colors.white),
                  ),

                ),

              ],
            ),
          ),

        ),
      );
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Radio(
            value: 1, groupValue: id,
            onChanged: (val) {

              setState(() {
                id = 1;
              });

            },
          ),
          Text('Einglish', style: new TextStyle(fontSize: 17.0),),

          Radio(
            value: 2,
            groupValue: id,
            onChanged: (val) {
              setState(() {

                id = 2;
              });
            },
          ),
          Text(
            'عربي',
            style: new TextStyle(
              fontSize: 17.0,
            ),
          ),

        ],
      ),
    );
  }
}


import 'dart:math';
import 'package:intl/intl.dart';
import 'package:my_medicine1/widget/image_container.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_medicine1/doctor/image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
class ChatPage extends StatefulWidget {
  String _DrIr,_PId,_ConId,DName;
  ChatPage(this._PId,this._DrIr,this._ConId,this.DName);

  @override
  _ChatPageState createState() => _ChatPageState();
}


class _ChatPageState extends State<ChatPage> {


  final _textController=TextEditingController();
  var _Massage='';
  StorageReference _storageReference;
  void  _onPressSendMassage(){
    FocusScope.of(context).unfocus();
    Firestore.instance.collection('/consultation/${widget._ConId}/chat').add({
      'content':_Massage,
      'from':widget._PId,
      'to':widget._DrIr,
      'time':DateTime.now(),
      'type':'text'
    });
    _textController.clear();
    _Massage='';
  }
  @override
  Widget build(BuildContext context) {
    String Da(Timestamp date) {
      final Timestamp timestamp = date as Timestamp;
      DateTime d = timestamp.toDate();
      String s = '';
      s = DateFormat('yyyy-MM-dd-h-mm').format(d);
      return s;
    }
    pickImage()async{
      File  imageSelected=await pickImageSource(source: ImageSource.gallery);
      uploadeimage(imageSelected,widget._PId,widget._DrIr);
    }
    return Scaffold(appBar: AppBar(title:Text('Dr '+widget.DName+' Chat Room')),
      body: Container(
        child: Column( children: [
          Expanded(
            child:StreamBuilder(stream: Firestore.instance.collection('/consultation/${widget._ConId}/chat').orderBy('time',descending: true).snapshots(),builder: (ctx,snap){
              if(snap.hasData){
                return ListView.builder(shrinkWrap: true,reverse: true,itemCount: snap.data.documents.length,itemBuilder: (ctx,ind){
                  var fromMe=snap.data.documents[ind]['from']==widget._PId;
                  return Row(mainAxisAlignment:ind==snap.data.documents.length-1?MainAxisAlignment.center:fromMe?MainAxisAlignment.end:MainAxisAlignment.start,children: [
                    Container(constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.7),decoration: BoxDecoration(color:fromMe?Colors.greenAccent:Colors.grey[200],borderRadius: BorderRadius.circular(5),),padding: EdgeInsets.symmetric(horizontal:5 ,vertical:5),margin: EdgeInsets.symmetric(horizontal:16 ,vertical:10), child:
                    snap.data.documents[ind]['type']=='image'?NewImageNetwork(snap.data.documents[ind]['url']):Text(ind==snap.data.documents.length-1?Da(snap.data.documents[ind]['time']):snap.data.documents[ind]['content'],style: TextStyle(color: Colors.white),),)
                  ],
                  );
                });
              }
              if(ConnectionState.waiting==snap.connectionState){
                return Center(child: CircularProgressIndicator());
              }

              return Center(child: Text("No Data"),);

            }),
          ),
        Container(decoration: BoxDecoration(border:Border.all(color:Colors.grey[300]),borderRadius: BorderRadius.circular(16)),
            margin: EdgeInsets.symmetric(horizontal:5 ,vertical:5),
            padding: EdgeInsets.only(left: 2,bottom: 5),
            child: Row(
              children: [
                Expanded(
                    child: TextField(controller: _textController,
                      decoration: InputDecoration(hintText: 'Send Massage'),onChanged:(val){
                        setState(() {
                          _Massage=val;
                        });
                      } ,
                    )),
                IconButton(icon: Icon(Icons.camera_alt_outlined),onPressed:pickImage,color: Colors.green,),
                IconButton(icon: Icon(Icons.send), onPressed: _Massage.trim().isEmpty?null:_onPressSendMassage,color: Colors.green,)
              ],
            ),
          ),
        ],),
      ),
    );
  }
  Future<File>pickImageSource({@required ImageSource source})async{
    File imageSelected = await ImagePicker.pickImage(source: source);
    return imageCompress(imageSelected);
  }
  Future<File>imageCompress(File Image)async{
    final temporarydirectory= await getTemporaryDirectory();
    final path =temporarydirectory.path;
    int random_num =Random().nextInt(100000);
    img.Image image=img.decodeImage(Image.readAsBytesSync());
    img.copyResize(image,width: 500,height: 500);
    return new File('$path/img_$random_num.jpg')..writeAsBytesSync(img.encodeJpg(image,quality:85 ));
  }
  Future<String>UploadImageToStorage(File image)async{
    try{_storageReference=FirebaseStorage.instance.ref().child('${DateTime.now().millisecondsSinceEpoch+1}');
    StorageUploadTask _storageUploadTask =_storageReference.putFile(image);
    var url= await (await _storageUploadTask.onComplete).ref.getDownloadURL();
    return url;
    }catch(e){
      print(e);
      return null;
    }

  }
  Future setImage(String _from,String _to,String Imageurl,String type)async{
    await Firestore.instance.collection('/consultation/${widget._ConId}/chat').add({
      'from':_from,
      'to':_to,
      'time':DateTime.now(),
      'url':Imageurl,
      'type':type,
    });
  }
  void uploadeimage(File imageSelected, String from, String to) async{
    String url =await UploadImageToStorage(imageSelected);
    setImage(from, to, url,'image');
  }
}



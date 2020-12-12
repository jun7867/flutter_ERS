import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'home.dart';
class EditPage extends StatefulWidget {

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  User _user;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  File _image;
  @override
  void initState() {
    super.initState();
    _prepareService();
  }
  void _prepareService() async {
    _user = await _firebaseAuth.currentUser;
  }

  final picker = ImagePicker();
  Future _imgFromCamera() async {
    final image = await picker.getImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = File(image.path);
    });
  }

  Future _imgFromGallery() async {
    final image = await picker.getImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = File(image.path);
    });
  }
  Future uploadPic(BuildContext context) async{
    DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    print("test"+_image.path);
    File file = File(_image.path);

    // _image != null ? print("yes") : file=File('https://firebasestorage.googleapis.com/v0/b/mdcfinal.appspot.com/o/logo.png?alt=media&token=24041c70-4b96-4a30-b4b4-57006d10c445');

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(_name.text+'.jpg')
          .putFile(file);
      print("Success"+formattedDate);
    } catch (e) {
      print(e);
    }
  }
  void _handleGenderChange(String value) {
    setState(() {
      _radioValue = value;
    });
  }
  void _handleGenderChange2(String value) {
    setState(() {
      _radioValue2 = value;
    });
  }

  TextEditingController _name = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _description = TextEditingController();
  String _radioValue = "food";
  String _radioValue2 = "false";
  @override
  Widget build(BuildContext context) {
    final Record record = ModalRoute.of(context).settings.arguments;
    _name = TextEditingController(text: record.name);
    _price = TextEditingController(text: record.price.toString() );
    _description = TextEditingController(text: record.description);
    final _formKey = GlobalKey<FormState>();
    String _nameValue="test";
    int _priceValue=0;
    String _descriptionValue="test";
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Edit"),
        actions: <Widget>[
          FlatButton(
            child: Text('Save'),
            textColor: Colors.white,
            onPressed: () async {
              // _image != null ? print("yes") : _image=File('https://firebasestorage.googleapis.com/v0/b/mdcfinal.appspot.com/o/logo.png?alt=media&token=24041c70-4b96-4a30-b4b4-57006d10c445');
              uploadPic(context);
              print(_name.text);

              await FirebaseFirestore.instance.collection('item').doc(_name.text).update({
                'modified' : FieldValue.serverTimestamp(),
                'like': 0,
                'price': int.parse(_price.text),
                'description': _description.text,
                'category': _radioValue,
                'complete': _radioValue2,
                'user_uid': _firebaseAuth.currentUser.uid,

              }).then((value) => print('Edit'));


              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(),
                    settings: RouteSettings(
                      // arguments: product,
                    )
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        child: ListView(
            children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Padding(padding: EdgeInsets.fromLTRB(20.0,0,20.0,0)),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/ers-service.appspot.com/o/' +
                              record.name +
                              '.jpg?alt=media&token=97b17f7a-25f5-4d36-9f51-496600d6b5df',
                          fit: BoxFit.fitWidth,
                          width: 400,
                          height: 200,
                        ),
                      ),
                    ),

                    IconButton(   // NEW from here...
                      icon: Icon(Icons.camera_alt_outlined,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        print("click");
                        _showPicker(context);
                      },
                    ),
                    Container(
                      key: _formKey,
                      height: 400.0,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: <Widget>[
                          TextFormField(
                            validator: (value2) {
                              if (value2.isEmpty) {
                                return 'Please enter price';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            onSaved: (value2) => _priceValue = int.parse(value2),
                            controller: _price,
                            decoration: InputDecoration(
                              filled: true,
                              labelText: '심부름 가격(원)',
                            ),
                          ),
                          TextFormField(
                            validator: (value3) {
                              if (value3.isEmpty) {
                                return 'Please enter Confirm Password';
                              }
                              return null;
                            },
                            onSaved: (value3) => _descriptionValue = value3,
                            controller: _description,
                            decoration: InputDecoration(
                              filled: true,
                              labelText: '글 설명',
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text("카테고리: "),
                              Radio<String>(
                                value: "food",
                                groupValue: _radioValue,
                                onChanged: _handleGenderChange,
                              ),
                              Text("food"),
                              Radio<String>(
                                value: "etc",
                                groupValue: _radioValue,
                                onChanged: _handleGenderChange,
                              ),
                              Text("기타 심부름(etc)"),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("완료 여부: "),
                              Radio<String>(
                                value: "true",
                                groupValue: _radioValue2,
                                onChanged: _handleGenderChange2,
                              ),
                              Text("거래 완료"),
                              Radio<String>(
                                value: "false",
                                groupValue: _radioValue2,
                                onChanged: _handleGenderChange2,
                              ),
                              Text("거래 미완료"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]
              ),
              ],
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }


}

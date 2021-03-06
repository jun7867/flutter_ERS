import 'dart:io';

import 'home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
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
    final image =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  Future _imgFromGallery() async {
    final image =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  Future uploadPic(BuildContext context) async {
    DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    print("test" + _image.path);
    File file = File(_image.path);

    // _image != null ? print("yes") : file=File('https://firebasestorage.googleapis.com/v0/b/mdcfinal.appspot.com/o/logo.png?alt=media&token=24041c70-4b96-4a30-b4b4-57006d10c445');

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(_name.text + '.jpg')
          .putFile(file);
      print("Success" + formattedDate);
    } catch (e) {
      print(e);
    }
  }

  TextEditingController _name = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _description = TextEditingController();
  String _radioValue = "food";
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String _nameValue = "test";
    int _priceValue = 0;
    String _descriptionValue = "test";
    // bool boolInit = false;
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("글쓰기 페이지"),
        actions: <Widget>[
          FlatButton(
            child: Text('등록하기'),
            textColor: Colors.white,
            onPressed: () async {
              // _image != null ? print("yes") : _image=File('https://firebasestorage.googleapis.com/v0/b/mdcfinal.appspot.com/o/logo.png?alt=media&token=24041c70-4b96-4a30-b4b4-57006d10c445');
              uploadPic(context);
              print(_radioValue);

              await FirebaseFirestore.instance
                  .collection('item')
                  .doc(_name.text)
                  .set({
                "title": _name.text,
                "name": _name.text,
                'like': 0,
                'price': int.parse(_price.text),
                'description': _description.text,
                'time': FieldValue.serverTimestamp(),
                'category': _radioValue,
                'complete': "false",
                'user_uid': _firebaseAuth.currentUser.uid,
                'voteList': "null",
                "creator": _firebaseAuth.currentUser.displayName
              }).then((value) => print('Added'));

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(),
                    settings: RouteSettings(
                        // arguments: product,
                        )),
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
                    child: _image == null
                        ? Image.asset(
                            'assets/logo.png',
                            width: 500,
                            height: 240,
                            // fit: BoxFit.cover,
                          )
                        : Image.file(
                            _image,
                            width: 500,
                            height: 70,
                          ),
                  ),
                ),

                IconButton(
                  // NEW from here...
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.black,
                    size: 35,
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
                        validator: (value1) {
                          if (value1.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                        onSaved: (value1) => _nameValue = value1,
                        controller: _name,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: '제목',
                        ),
                      ),
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
                          Text("etc"),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
        ],
      )),
    );
  }

  void _handleGenderChange(String value) {
    setState(() {
      _radioValue = value;
    });
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
        });
  }
}

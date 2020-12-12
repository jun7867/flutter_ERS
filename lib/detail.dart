import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ers/services/database.dart';
import 'package:ers/views/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'edit.dart';
import 'home.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  getProfileImage() {
    if (_firebaseAuth.currentUser.photoURL != null) {
      return Image.network(_firebaseAuth.currentUser.photoURL,
          height: 50, width: 50);
    } else {
      return Image.asset(
        "assets/logo.png",
        width: 50,
        height: 50,
      );
    }
  }

  getEmail() {
    if (_firebaseAuth.currentUser.email != null) {
      return Text(_firebaseAuth.currentUser.email,
          style: TextStyle(fontSize: 30));
    } else {
      return Text("Anonymous", style: TextStyle(fontSize: 30));
    }
  }
  sendMessage(String userName){

    List<String> users = [_firebaseAuth.currentUser.displayName,userName];
    String chatRoomId = getChatRoomId(_firebaseAuth.currentUser.displayName,userName);
    // String chatRoomId = getChatRoomId('nam',userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };
    print("In search Page"+chatRoomId+"  "+chatRoom.toString());

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(context, MaterialPageRoute(
        builder: (context) => Chat(
          chatRoomId: chatRoomId,
        )
    ));

  }
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    final Record record = ModalRoute.of(context).settings.arguments;

    var date = record.time.millisecondsSinceEpoch;
    var dateTime = DateTime.fromMillisecondsSinceEpoch(date);

    print("voteList :  " + record.voteList);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        // backgroundColor: Color(0x00ff0000),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(""),
        actions: <Widget>[
          IconButton(
              icon: new Icon(Icons.edit),
              onPressed: () => {
                    if (record.user_uid == _firebaseAuth.currentUser.uid)
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditPage(),
                                settings: RouteSettings(
                                  arguments: record,
                                )))
                      }
                    else{
                       showAlertDialog(context)
                    }
                  }),
          IconButton(
              icon: new Icon(Icons.delete),
              onPressed: () => {
                    if (record.user_uid == _firebaseAuth.currentUser.uid)
                      {
                        FirebaseFirestore.instance
                            .collection('item')
                            .doc(record.name)
                            .delete(),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(),
                              settings: RouteSettings()),
                        )
                      },
                  }),
        ],
      ),
      body: Container(
        color: Color.fromRGBO(255, 255, 255, 1),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.fromLTRB(0.0, 0, 20.0, 0)),
                ClipRRect (
                  borderRadius: BorderRadius.circular(10.0), // 동그랗게 만들기
                  child: Image.network (
                    'https://firebasestorage.googleapis.com/v0/b/ers-service.appspot.com/o/' +
                        record.name +
                        '.jpg?alt=media&token=97b17f7a-25f5-4d36-9f51-496600d6b5df',
                    fit: BoxFit.fitWidth,
                    width: 500,
                    height: 200,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.fromLTRB(0, 20, 20.0, 10)),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30.0), // 동그랗게 만들기
                        child: getProfileImage(),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        record.creator,
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 40)),
                      Text(
                        "제목",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Padding(
                                padding:
                                EdgeInsets.fromLTRB(10.0, 0, 10.0, 40)),
                            Text(
                              record.title,
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(20.0, 0, 10, 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      // 여기다가 padding 추가
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "가격    ",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "\₩ " + record.price.toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Text(
                                "내용    ",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                overflow: TextOverflow.clip,
                                softWrap: true,
                              ),
                              SizedBox(
                                width:
                                MediaQuery.of(context).size.width / 3 * 2,
                                child: Text(
                                  record.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.clip,
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14.0),
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            10.0, 0, 10.0, 0)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          record.complete == "true" ? "현재 상태 :  거래 완료" : "현재상태:  거래 미완료",
                          style: TextStyle(fontSize: 20),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async => {
                                    if (record.voteList !=
                                        _firebaseAuth.currentUser.uid)
                                      {
                                        await record.reference.update({
                                          'like': FieldValue.increment(1),
                                          'voteList':
                                          _firebaseAuth.currentUser.uid,
                                        }),
                                        scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                            content:
                                            Text("I like it"))),
                                      }
                                    else
                                      {
                                        scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                            content: Text(
                                                "You can only do it once!!")))
                                      },
                                  }),
                              Text(
                                record.like.toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 5,
                          color: Colors.black,
                        ),
                      ],
                    )),
                GestureDetector(
                  onTap: () {
                    sendMessage(record.creator);
                  },
                  child: Container(
                    //alignment: Alignment.bottomRight,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xff007EF4),
                            const Color(0xff2A75BC)
                          ],
                        )),
                    width: MediaQuery.of(context).size.width / 3,
                    child: Text(
                      "채팅하기",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Text(
                  "게시글 작성일:  " + dateTime.toString(),
                  style: TextStyle(fontSize: 15),
                ),
              ],

            ),
          ],
        ),
      ),
    );
  }
  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog'),
          content: Text("글의 작성자가 아닙니다."),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context, "OK");
              },
            ),
          ],
        );
      },
    );

    scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text("글 작성자를 확인해주세요"),
          backgroundColor: Colors.orange,
          action: SnackBarAction(
            label: "Done",
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
  }
}

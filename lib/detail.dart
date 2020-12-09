// import 'package:Shrine/edit.dart';
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
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(padding: EdgeInsets.fromLTRB(0.0, 0, 20.0, 0)),
                Center(
                  child: Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/ers-service.appspot.com/o/' +
                        record.name +
                        '.png?alt=media&token=97b17f7a-25f5-4d36-9f51-496600d6b5df',
                    fit: BoxFit.fitWidth,
                    width: 500,
                    height: 200,
                  ),
                ),

                Container(
                  child: Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.fromLTRB(0, 10, 20.0, 10)),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: getProfileImage(),
                      ), // 동그랗게 만들기
                      Text(
                        _firebaseAuth.currentUser.email,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0)),
                      Text(
                        record.title,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Container(
                    child: Column(
                  // 여기다가 padding 추가
                  children: <Widget>[
                    Padding(padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10)),
                    Text(record.complete ? "현재 상태:  거래 완료" : "현재상태:  거래 미완료"),
                    Text(
                      "\$ " + record.price.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                    Divider(
                      height: 5,
                      color: Colors.black,
                    ),
                    Text(
                      record.description,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )),

                Text(
                  "작성자: " + record.creator,
                  style: TextStyle(fontSize: 15),
                ),
                // Text(
                //   "게시글 작성일:  " + dateTime.toString(),
                //   style: TextStyle(fontSize: 15),
                // ),

                Container(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.thumb_up,
                            color: Colors.red,
                          ),
                          onPressed: () async => {
                                if (record.voteList !=
                                    _firebaseAuth.currentUser.uid)
                                  {
                                    await record.reference.update({
                                      'like': FieldValue.increment(1),
                                      'voteList': _firebaseAuth.currentUser.uid,
                                    }),
                                    scaffoldKey.currentState.showSnackBar(
                                        SnackBar(content: Text("I like it"))),
                                  }
                                else
                                  {
                                    scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
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
                GestureDetector(
                  onTap: () {
                    sendMessage(record.creator);
                  },
                  child: Container(
                    child: Text('채팅하기',
                        style: TextStyle(fontSize: 24, color: Colors.amber)),
                    // color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

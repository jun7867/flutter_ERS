import 'package:ers/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'add.dart';
import 'chatrooms.dart';
import 'login.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  int _selectedIndex = 3;
  final _widgetOptions=[
    Text('index 0: Home'),
    Text('index 1: Search'),
    Text('index 2: Mypage'),
  ];

  _tapNavBar(index) {
    print('Tapped!'+index.toString());
    if (index==0){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(),
            settings: RouteSettings(
              // arguments: product,
            )),
      );
    }
    if (index==1){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddPage(),
            settings: RouteSettings(
              // arguments: product,
            )),
      );
    }
    if (index==2){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatRoom(),
            settings: RouteSettings(
              // arguments: product,
            )),
      );
    }
    if (index==3){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyPage(),
            settings: RouteSettings(
              // arguments: product,
            )),
      );
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  getProfileImage() {
    if (_firebaseAuth.currentUser.photoURL != null) {
      return Image.network(_firebaseAuth.currentUser.photoURL,
          height: 150, width: 500);
    } else {
      return Image.asset(
        "assets/logo.png",
        width: 500,
        height: 250,
      );
    }
  }

  getEmail() {
    if (_firebaseAuth.currentUser.email != null) {
      return Text("Email :  "+_firebaseAuth.currentUser.email,
          style: TextStyle(fontSize: 24));
    } else {
      return Text("Anonymous", style: TextStyle(fontSize: 30));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.exit_to_app),
            onPressed: () async => {
              //log-out
              await FirebaseAuth.instance.signOut(),
              // await googleSignIn.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage(),
                    settings: RouteSettings(
                        // arguments: product,
                        )),
              ),
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0)),
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0), // 동그랗게 만들기
              child: getProfileImage(),
            ),
            Text(
              _firebaseAuth.currentUser.displayName != null
                  ? "ID(Name) :  "+ _firebaseAuth.currentUser.displayName
                  : "Name",
              style: TextStyle(fontSize: 24),
            ),
            Divider(
              height: 5,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: getEmail(),
            ),
            SizedBox(height: 30,),
            GestureDetector(
              onTap: () {
                // AuthService().signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ChatRoom()));
              },
              child: Container(

                child: Text('메세지함 이동', style: TextStyle(fontSize: 24,color: Colors.amber)),
                // color: Colors.white,
              ),
            )

          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: '글쓰기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: '채팅방',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: '마이페이지',
          ),
        ],
        fixedColor: Colors.black,
        onTap: _tapNavBar,
      ),
    );
  } // ...to here.
}

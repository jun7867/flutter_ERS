import 'package:ers/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'add.dart';
import 'login.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  int _selectedIndex = 1;
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
            builder: (context) => HomePage(),
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
          height: 250, width: 500);
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
      return Text(_firebaseAuth.currentUser.email,
          style: TextStyle(fontSize: 30));
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
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: getProfileImage(),
            ),
            Text(
              _firebaseAuth.currentUser.displayName != null
                  ? _firebaseAuth.currentUser.displayName
                  : "Name",
              style: TextStyle(fontSize: 20),
            ),
            Divider(
              height: 5,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: getEmail(),
            ),
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
            backgroundColor: Colors.white,
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'search',
          ),
        ],
        fixedColor: Colors.pink,
        onTap: _tapNavBar,
      ),
    );
  } // ...to here.
}

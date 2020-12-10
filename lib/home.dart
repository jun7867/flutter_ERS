import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'add.dart';
import 'chatrooms.dart';
import 'detail.dart';
import 'myPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String dropdownValue = 'ASC';
  int _selectedIndex = 0;

  _tapNavBar(index) {
    print('Tapped!' + index.toString());
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(),
            settings: RouteSettings(
                // arguments: product,
                )),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddPage(),
            settings: RouteSettings(
                // arguments: product,
                )),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatRoom(),
            settings: RouteSettings(
                // arguments: product,
                )),
      );
    }
    if (index == 3) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.person_rounded,
            semanticLabel: 'menu',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyPage(),
                  settings: RouteSettings(
                      // arguments: product,
                      )),
            );
          },
        ),
        title: Dropdown(context),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              semanticLabel: 'filter',
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddPage(),
                    settings: RouteSettings(
                        // arguments: product,
                        )),
              );
            },
          ),
        ],
      ),
      body: _buildGridCards(context),
      bottomNavigationBar: BottomNavigationBar(
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
  }

  Widget Dropdown(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 12,
      elevation: 16,
      underline: Container(
        margin: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items:
          <String>['ASC', 'DESC'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(' ' + value),
        );
      }).toList(),
    );
  }

  Widget _buildGridCards(BuildContext context) {
    bool checkASC = false;
    dropdownValue == 'ASC' ? checkASC = false : checkASC = true;
    String priceformat = "₩ ";
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('item')
              .orderBy('price', descending: checkASC)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text("Loading...");
              default:
                return GridView.count(
                  //   return ListView.builder(
                  crossAxisCount: 1,
                  padding: EdgeInsets.all(16.0),
                  childAspectRatio: 8.0 / 6.0,
                  children: snapshot.data.docs.map((data) {
                    final record = Record.fromSnapshot(data);
                    final ThemeData theme = Theme.of(context);
                    final NumberFormat formatter = NumberFormat.simpleCurrency(
                        locale: Localizations.localeOf(context).toString());
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AspectRatio(
                            // aspectRatio: 18 / 11,
                            aspectRatio: 32 / 15,
                            child: Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/ers-service.appspot.com/o/' +
                                  record.name +
                                  '.jpg?alt=media&token=97b17f7a-25f5-4d36-9f51-496600d6b5df',
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    record.title,
                                    style: theme.textTheme.subtitle1,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    // formatter.format(record.price),
                                    priceformat + record.price.toString(),
                                    style: theme.textTheme.subtitle1,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          4.0, 4.0, 4.0, 0.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            record.complete.toString() ==
                                                    "false"
                                                ? "거래 미완료"
                                                : "거래 완료",
                                            style: theme.textTheme.subtitle2,
                                          ),
                                          FlatButton(
                                            padding: EdgeInsets.only(
                                                left: 200, top: 0, bottom: 0),
                                            child: Text(
                                              'more',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            textColor: Colors.blue,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailPage(),
                                                    settings: RouteSettings(
                                                      arguments: record,
                                                    )),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
            }
          }),
    );
  }
}

class Record {
  final String name;
  final int like;
  final int price;
  final String description;
  final Timestamp time;
  final String title;
  final DocumentReference reference;
  final String user_uid;
  final String voteList;
  final String category;
  final String creator;
  final bool complete;


  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['like'] != null),
        assert(map['price'] != null),
        assert(map['time'] != null),
        assert(map['title'] != null),
        assert(map['user_uid'] != null),
        assert(map['voteList'] != null),
        assert(map['description'] != null),
        assert(map['category'] != null),
        assert(map['complete'] != null),
        assert(map['creator'] != null),
        name = map['name'],
        like = map['like'],
        price = map['price'],
        time = map['time'],
        title = map['title'],
        user_uid = map['user_uid'],
        voteList = map['voteList'],
        category = map['category'],
        complete = map['complete'],
        description = map['description'],
        creator = map['creator'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() =>
      "Record<$name:$like$price$description$time$user_uid$title$voteList$category$complete$creator>";
}

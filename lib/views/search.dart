import 'package:ers/helper/constants.dart';
import 'package:ers/models/user.dart';
import 'package:ers/services/database.dart';
import 'package:ers/views/chat.dart';
import 'package:ers/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    print("what!");
    if(searchEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await databaseMethods.searchByName(searchEditingController.text)
          .then((snapshot){
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList(){
    return haveUserSearched ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchResultSnapshot.docs.length,
        itemBuilder: (context, index){
        return userTile(
          searchResultSnapshot.docs[index].data()["userName"] ,
          searchResultSnapshot.docs[index].data()["userEmail"] ,
        );
        }) : Container();
  }

  /// 1.create a chatroom, send user to the chatroom, other userdetails
  sendMessage(String userName){

    List<String> users = [Constants.myName,userName];

    String chatRoomId = getChatRoomId(Constants.myName,userName);
    print("fifzzi");
    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);
    print("clciclciclci");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Chat(),
          settings: RouteSettings(
            arguments: chatRoomId,
          )),
    );

    // Navigator.push(context, MaterialPageRoute(
    //   builder: (context) => Chat(
    //     chatRoomId: chatRoomId,
    //   )
    // ));

  }

  Widget userTile(String userName,String userEmail){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16
                ),
              ),
              Text(
                userEmail,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16
                ),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              print("clickkkkkk");
              sendMessage(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(24)
              ),
              child: Text("Message",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
            ),
          )
        ],
      ),
    );
  }


  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String _nameValue = "test";
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              // color: Colors.white,
              // color: Color(0x54FFFFFF),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchEditingController,
                      // style: simpleTextStyle(),

                      decoration: InputDecoration(
                        hintText: "search username ...",
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                      print("click");
                    },
                    child: Container(
                      height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          // color: Colors.,
                          borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(12),
                        child: Image.asset("assets/search_white.png",
                          color: Colors.black,
                          height: 25, width: 25,)),
                  )
                ],
              ),
            ),
            userList()
          ],
        ),
      ),
    );
  }
}



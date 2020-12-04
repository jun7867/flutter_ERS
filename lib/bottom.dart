// Card 위젯 구현
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Red extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Card(color: Colors.red);
  }
}

// Text 위젯 구현
class Green extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Container(
      child: Center(
          child:Text('GREEN', style: TextStyle(fontSize: 31, color: Colors.white))
      ),
      color: Colors.green,
      margin: EdgeInsets.all(6.0),
    );
  }
}

// Icon 위젯 구현
class Blue extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Container(
      child: Center(
        child: Icon(Icons.table_chart, size: 150, color: Colors.white),
      ),
      color: Colors.blue,
      margin: EdgeInsets.all(6.0),
    );
  }
}

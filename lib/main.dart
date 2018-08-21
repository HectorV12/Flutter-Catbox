import 'package:catbox/ui/catList.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(new CatBoxApp());
}

class CatBoxApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.blueGrey,
        fontFamily: 'Ubuntu',
      ),
      home: new CatList(),
    );
  }
}
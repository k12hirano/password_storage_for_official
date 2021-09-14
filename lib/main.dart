import 'package:flutter/material.dart';
import 'package:password_storage_for_official/root.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'password storage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: Root(),
    );
  }
}
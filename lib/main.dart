import 'package:flutter/material.dart';
import 'package:flutter_ui_login/views/login.dart';
import 'package:flutter_ui_login/views/signup.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(),
        '/login': (BuildContext context) => new Login()
      },
      home: Login(),
    );
  }
}

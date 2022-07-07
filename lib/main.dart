import 'package:flutter/material.dart';
import 'package:flutter_ui_login/constant.dart';

import 'package:flutter_ui_login/views/authentication/login.dart';
import 'package:flutter_ui_login/views/authentication/signup.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: maincolore,
        primaryColor: maincolore1,
      ),
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(),
        '/login': (BuildContext context) => new Login()
      },
      home: Login(),
    );
  }
}

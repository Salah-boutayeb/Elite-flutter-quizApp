import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key key, this.user}) : super(key: key);
  final user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QUIZ RSI"),
      ),
      body: Column(children: [
        Container(
          child: Text("welcome" + user),
        )
      ]),
    );
  }
}

import "package:flutter/material.dart";
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DropApi extends StatefulWidget {
  @override
  _DropApiState createState() => _DropApiState();
}

class _DropApiState extends State<DropApi> {
  String mySelection;

  final String url = "http://192.168.1.14:5555/api/categories";

  List data = []; //edited line

  Future<String> getSWData() async {
    var res =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);
    print(resBody);
    setState(() {
      data = resBody;
    });

    print(resBody);

    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    this.getSWData();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new DropdownButton(
        hint: Text("Categories"),
        value: mySelection,
        items: data.map((item) {
          return new DropdownMenuItem(
            child: new Text(item['name']),
            value: item['id'].toString(),
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            mySelection = newVal;
          });
        },
      ),
    );
  }
}

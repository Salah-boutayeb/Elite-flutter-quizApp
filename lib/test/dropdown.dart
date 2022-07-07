import 'package:flutter/material.dart';
import 'package:elite_quiz/constant.dart';
import 'package:elite_quiz/services/addCategory.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddQuiz extends StatefulWidget {
  final categoryid;
  const AddQuiz({Key key, this.categoryid}) : super(key: key);

  @override
  State<AddQuiz> createState() => _AddQuizState();
}

class _AddQuizState extends State<AddQuiz> {
  String mySelection;

  final String url = "http://localhost:5555/api/categories";

  List data = [];

  Future<String> getcategories() async {
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
    this.getcategories();
    mySelection = widget.categoryid;
  }

  String question;
  String a;
  String a1;
  String a2;
  String a3;

  final TextEditingController questionctl = TextEditingController();
  final TextEditingController correct = TextEditingController();
  final TextEditingController answer1 = TextEditingController();
  final TextEditingController answer2 = TextEditingController();
  final TextEditingController answer3 = TextEditingController();

  clearText() {
    questionctl.clear();
    correct.clear();
    answer1.clear();
    answer2.clear();
    answer3.clear();
  }

  Map<String, dynamic> answers = new Map<String, dynamic>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 80.0, 0.0, 0.0),
                  child: Text(
                    'Add QUIZ',
                    style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                      color: pripmaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: new DropdownButton(
                    hint: Text("Categories"),
                    value: mySelection,
                    items: data.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['name']),
                        value: item['_id'].toString(),
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {
                        mySelection = newVal;
                      });
                    },
                  ),
                ),
                TextField(
                  onChanged: (value) => question = value,
                  decoration: InputDecoration(
                    labelText: 'question',
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  controller: questionctl,
                ),
                SizedBox(height: 10.0),
                TextField(
                  onChanged: (value) {
                    a = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'correct answer is here ... ',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  controller: correct,
                ),
                SizedBox(height: 10.0),
                TextField(
                  onChanged: (value) {
                    a1 = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'any answer ... ',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: maincolore1),
                    ),
                  ),
                  controller: answer1,
                ),
                SizedBox(height: 10.0),
                TextField(
                  onChanged: (value) {
                    a2 = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'any answer ... ',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: maincolore1),
                    ),
                  ),
                  controller: answer2,
                ),
                SizedBox(height: 10.0),
                TextField(
                  onChanged: (value) {
                    a3 = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'any answer ... ',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: maincolore1),
                    ),
                  ),
                  controller: answer3,
                ),
                SizedBox(height: 90.0),
                Container(
                  height: 40.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.greenAccent,
                    color: maincolore,
                    elevation: 7.0,
                    child: GestureDetector(
                      onTap: () {
                        answers[a] = true;
                        answers[a1] = false;
                        answers[a2] = false;
                        answers[a3] = false;

                        CRUDService()
                            .addQuiz(
                              question: question,
                              answers: answers,
                              category: mySelection,
                            )
                            .then(
                              (value) => {
                                print(value),
                              },
                            );
                        //clearText();
                      },
                      child: Center(
                        child: Text(
                          'add to quiz',
                          style: TextStyle(
                              color: maincolore1,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

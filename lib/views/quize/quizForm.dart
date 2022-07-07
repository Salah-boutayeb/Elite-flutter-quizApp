import 'package:flutter/material.dart';
import 'package:flutter_ui_login/constant.dart';
import 'package:flutter_ui_login/models/userModel.dart';
import 'package:flutter_ui_login/services/addCategory.dart';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_ui_login/views/authentication/login.dart';
import 'package:flutter_ui_login/views/quize/categories.dart';
import 'package:flutter_ui_login/views/quize/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddQuiz extends StatefulWidget {
  final categoryid;
  const AddQuiz({Key key, this.categoryid, this.user}) : super(key: key);
  final User user;
  @override
  State<AddQuiz> createState() => _AddQuizState();
}

class _AddQuizState extends State<AddQuiz> {
  String mySelection;
  User user;

  @override
  void initState() {
    super.initState();
    user = widget.user;

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
      bottomNavigationBar: ConvexAppBar(
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.category, title: 'Quiz'),
          TabItem(icon: Icons.logout_outlined, title: 'logout'),
        ],
        //optional, default as 0
        onTap: (int i) async {
          final prefs = await SharedPreferences.getInstance();

          if (i == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(user: widget.user),
              ),
            );
          } else if (i == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Categories(user: widget.user),
              ),
            );
          } else {
            prefs.setString("token", null);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Login(),
              ),
            );
          }
        },
      ),
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
                SizedBox(height: 40.0),
                Container(
                  height: 40.0,
                  width: 100,
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
                        clearText();
                        //optional
                        answers = new Map<String, dynamic>();
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

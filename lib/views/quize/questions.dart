import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_login/constant.dart';
import 'package:flutter_ui_login/models/questionModel.dart';
import 'package:flutter_ui_login/models/userModel.dart';
import 'package:flutter_ui_login/views/authentication/login.dart';
import 'package:flutter_ui_login/views/quize/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'categories.dart';

class QuizTest extends StatefulWidget {
  final idCategory;

  final user;
  const QuizTest({Key key, this.idCategory, this.user}) : super(key: key);

  @override
  State<QuizTest> createState() => _QuizTestState();
}

class _QuizTestState extends State<QuizTest> {
  int question_pos = 0;
  Future<List<Question>> questions;
  int score = 0;
  bool btnPressed = false;
  PageController _controller;
  String btnText = "Next Question";
  bool answered = false;
  User user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = widget.user;
    score = widget.user.score;
    questions = getQuestions(widget.idCategory);
    _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("widget.user")),
        backgroundColor: pripmaryColor,
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
              child: FutureBuilder<List<Question>>(
            future: questions,
            builder: ((
              context,
              snapshot,
            ) {
              if (snapshot.hasData) {
                return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: PageView.builder(
                      controller: _controller,
                      onPageChanged: (page) {
                        if (page == snapshot.data.length - 1) {
                          setState(() {
                            btnText = "See Results";
                          });
                        }
                        setState(() {
                          answered = false;
                        });
                      },
                      physics: new NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                "Question ${index + 1}/${snapshot.data.length}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28.0,
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 200.0,
                              child: Text(
                                "${snapshot.data[index].question}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.0,
                                ),
                              ),
                            ),
                            for (int i = 0;
                                i < snapshot.data[index].answers.length;
                                i++)
                              Container(
                                width: double.infinity,
                                height: 50.0,
                                margin: EdgeInsets.only(
                                    bottom: 20.0, left: 12.0, right: 12.0),
                                child: RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  fillColor: btnPressed
                                      ? snapshot.data[index].answers.values
                                              .toList()[i]
                                          ? Colors.green
                                          : Colors.red
                                      : secondaryColor,
                                  onPressed: !answered
                                      ? () {
                                          if (snapshot
                                              .data[index].answers.values
                                              .toList()[i]) {
                                            score += 5;
                                            print("yes");
                                          } else {
                                            print("no");
                                          }
                                          setState(() {
                                            btnPressed = true;
                                            answered = true;
                                          });
                                        }
                                      : null,
                                  child: Text(
                                      snapshot.data[index].answers.keys
                                          .toList()[i],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      )),
                                ),
                              ),
                            SizedBox(
                              height: 40.0,
                            ),
                            RawMaterialButton(
                              onPressed: () {
                                if (_controller.page?.toInt() ==
                                    snapshot.data.length - 1) {
                                  updateScore(score, user.id).then((value) {
                                    print(value);
                                    user.score = value.data['score'];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Home(user: user),
                                      ),
                                    );
                                  });
                                } else {
                                  _controller.nextPage(
                                      duration: Duration(milliseconds: 250),
                                      curve: Curves.easeInExpo);

                                  setState(() {
                                    btnPressed = false;
                                  });
                                }
                              },
                              shape: StadiumBorder(),
                              fillColor: Colors.blue,
                              padding: EdgeInsets.all(18.0),
                              elevation: 0.0,
                              child: Text(
                                btnText,
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        );
                      },
                      itemCount: snapshot.data.length,
                    ));
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return CircularProgressIndicator();
              }
            }),
          )),
        ));
  }
}

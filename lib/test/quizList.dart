import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import 'package:elite_quiz/constant.dart';
import 'package:elite_quiz/models/categoryModel.dart';
import 'package:elite_quiz/models/userModel.dart';
import 'package:elite_quiz/views/quize/categories.dart';
import 'package:elite_quiz/views/quize/questions.dart';
import 'package:elite_quiz/views/quize/quizForm.dart';

import 'package:shared_preferences/shared_preferences.dart';

class QuizList extends StatefulWidget {
  const QuizList({Key key, this.user}) : super(key: key);
  final user;
  @override
  State<QuizList> createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
  Future<List<Category>> categories;
  User user;
  var newVal;
  initState() {
    super.initState();
    user = widget.user;
    categories = getcategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: categories,
        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, index) => InkWell(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 2.0, color: Color.fromARGB(255, 21, 17, 17)),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.fromLTRB(50, 25, 15, 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(snapshot.data[index].name.toString().toUpperCase()),
                    Container(
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () async {
                              await _showTextInputDialog(
                                context,
                                idCategory: snapshot.data[index].id,
                                categoryName: snapshot.data[index].name,
                              );
                            },
                            child: Icon(
                              Icons.edit_location_alt_outlined,
                              color: Colors.greenAccent[600],
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              Dio dio = new Dio();
                              final prefs =
                                  await SharedPreferences.getInstance();
                              try {
                                dio.options.headers['content-Type'] =
                                    'application/json';
                                dio.options.headers["authorization"] =
                                    "Bearer ${prefs.getString("token")}";

                                return await dio
                                    .delete(
                                      '${url}categories?idCategory=${snapshot.data[index].id}',
                                    )
                                    .then((value) => {
                                          print(value),
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Categories(),
                                            ),
                                            (Route<dynamic> route) => false,
                                          )
                                        });
                              } on DioError catch (e) {
                                print(e);
                              }
                            },
                            child: Icon(
                              Icons.remove_circle_outline_outlined,
                              color: Colors.deepOrangeAccent,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              print("add");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddQuiz(
                                    categoryid: snapshot.data[index].id,
                                  ),
                                ),
                              );
                            },
                            child: Icon(Icons.add_circle,
                                color: Colors.cyanAccent),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizTest(
                      idCategory: snapshot.data[index].id,
                      user: user,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  final _textFieldController = TextEditingController();

  _showTextInputDialog(
    BuildContext context, {
    idCategory,
    categoryName,
  }) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("update : ${categoryName}"),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "new category name"),
              onChanged: (value) {
                newVal = value;
              },
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("update"),
                onPressed: () {
                  updateCategory(idCategory, newVal);
                  print(newVal);
                  newVal = "";
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) => Categories(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          );
        });
  }
}

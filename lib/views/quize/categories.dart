import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_login/constant.dart';
import 'package:flutter_ui_login/models/categoryModel.dart';
import 'package:flutter_ui_login/models/userModel.dart';
import 'package:flutter_ui_login/views/authentication/login.dart';
import 'package:flutter_ui_login/views/quize/home.dart';
import 'package:flutter_ui_login/views/quize/questions.dart';
import 'package:flutter_ui_login/views/quize/quizForm.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Categories extends StatefulWidget {
  const Categories({Key key, this.user}) : super(key: key);
  final user;

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
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
      backgroundColor: secondaryColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add your onPressed code here!
          await _showTextInputDialog(
            context,
          );
        },
        backgroundColor: maincolore1,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: ConvexAppBar(
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.category, title: 'Quiz'),
          TabItem(icon: Icons.logout_outlined, title: 'logout'),
        ],
        //optional, default as 0
        initialActiveIndex: 1,
        onTap: (int i) async {
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Login(),
              ),
            );
          }
        },
      ),
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
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 25),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, index) => InkWell(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: pripmaryColor),
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
                                    user: user,
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
            title: Text("Category"),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "new category name"),
              onChanged: (value) {
                newVal = value;
              },
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("submit"),
                onPressed: () {
                  print(newVal);
                  if (categoryName == null || idCategory == null) {
                    addCategory(newVal).then((val) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) => Categories(
                            user: widget.user,
                          ),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    });
                  } else {
                    updateCategory(idCategory, newVal).then((val) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) => Categories(
                            user: widget.user,
                          ),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    });
                  }

                  newVal = "";
                },
              ),
            ],
          );
        });
  }
}

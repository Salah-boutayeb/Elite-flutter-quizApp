import 'package:dio/dio.dart';
import 'package:flutter_ui_login/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  var id;
  var name;
  var email;
  var score;
  User({this.id, this.email, this.name, this.score});
  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      name: ["name"],
      email: json["email"],
      score: json["score"]);
}

updateScore(score, id) async {
  Dio dio = new Dio();
  print('post score');
  final prefs = await SharedPreferences.getInstance();
  try {
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer ${prefs.getString("token")}";
    return await dio.post(
      '${url}users/score',
      data: {"id": id, "score": score},
    );
  } catch (e) {}
}

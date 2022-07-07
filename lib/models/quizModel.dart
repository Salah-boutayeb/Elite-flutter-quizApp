import 'package:dio/dio.dart';
import 'package:flutter_ui_login/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Quiz {
  var title;
  var points;
  Quiz({this.title, this.points});
  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        title: json["title"],
        points: json["points"],
      );
}

Future<List<Quiz>> getQuizes(id) async {
  Dio dio = new Dio();
  List<Quiz> quizes = [];
  final prefs = await SharedPreferences.getInstance();
  try {
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer ${prefs.getString("token")}";
    await dio
        .get(
          '${url}quiz/category?id=${id}',
        )
        .then((value) => {
              print(value),
              for (var quiz in value.data)
                {
                  {
                    quizes.add(
                      new Quiz(title: quiz['title'], points: quiz['points']),
                    )
                  }
                }
            });
    return quizes;
  } on DioError catch (e) {
    print(e);
  }
  return quizes;
}

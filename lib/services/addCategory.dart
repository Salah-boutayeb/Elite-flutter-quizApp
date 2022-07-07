import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CRUDService {
  Dio dio = new Dio();

  addQuiz(
      {String question, Map<String, dynamic> answers, String category}) async {
    final prefs = await SharedPreferences.getInstance();

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer ${prefs.getString("token")}";
    try {
      return await dio.post(
        'http://localhost:5555/api/quiz',
        data: {
          "question": question,
          "answers": answers,
          "category": category,
        },
      );
    } catch (e) {
      print(e.message);
    }
  }

  addCategories() async {
    try {
      return await dio.post(
        'http://localhost:5555/api/',
        data: {},
      );
    } catch (e) {}
  }
}

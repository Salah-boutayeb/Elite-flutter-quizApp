import 'package:dio/dio.dart';

class CRUDService {
  Dio dio = new Dio();

  addQuiz(
      {String question, Map<String, dynamic> answers, String category}) async {
    try {
      return await dio.post(
        'http://192.168.1.14:5555/api/quiz',
        data: {"question": question, "answers": answers, "category": category},
      );
    } catch (e) {
      print(e.message);
    }
  }

  addCategories() async {
    try {
      return await dio.post(
        'http://192.168.1.21:5555/api/',
        data: {},
      );
    } catch (e) {}
  }
}

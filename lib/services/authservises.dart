import 'package:dio/dio.dart';
import 'package:elite_quiz/constant.dart';

class AuthServises {
  Dio dio = new Dio();

  login(name, password) async {
    //final prefs = await SharedPreferences.getInstance();
    try {
      return await dio.post(
        '${url}users/login',
        data: {"email": name, "password": password},
      );
    } on DioError catch (e) {
      print(e);
    }
  }

  signup(name, email, password) async {
    try {
      return await dio.post(
        '${url}users/signup',
        data: {"name": name, "email": email, "password": password},
      );
    } on DioError catch (e) {
      print(e);
    }
  }
}

import 'package:dio/dio.dart';

class AuthServises {
  Dio dio = new Dio();

  login(name, password) async {
    try {
      return await dio.post(
        'http://192.168.1.21:5555/api/users/login',
        data: {"email": name, "password": password},
      );
    } on DioError catch (e) {
      print(e);
    }
  }

  signup(name, email, password) async {
    try {
      return await dio.post(
        'http://192.168.1.10:5555/api/users/signup',
        data: {"name": name, "email": email, "password": password},
      );
    } on DioError catch (e) {
      print(e);
    }
  }
}

import 'package:dio/dio.dart';

class Quiz {
  var title;
  var points;
  Quiz({this.title, this.points});
}

Future<List<Quiz>> getQuizes(id) async {
  Dio dio = new Dio();
  List<Quiz> quizes = [];

  try {
    await dio
        .get(
          'http://192.168.1.21:5555/api/quizes/category/${id}',
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

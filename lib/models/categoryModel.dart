import 'package:dio/dio.dart';
import 'package:elite_quiz/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Category {
  var id;
  var name;
  Category({this.id, this.name});
}

Future<List<Category>> getcategories() async {
  Dio dio = new Dio();
  List<Category> categories = [];
  final prefs = await SharedPreferences.getInstance();
  try {
    dio.options.headers["authorization"] = "Bearer ${prefs.getString("token")}";
    await dio
        .get(
          '${url}categories',
        )
        .then((value) => {
              if (value.statusCode == 200)
                {
                  print(value),
                  for (var category in value.data)
                    {
                      {
                        categories.add(
                          new Category(
                            name: category['name'],
                            id: category['_id'],
                          ),
                        )
                      }
                    }
                }
              else
                {print("no category found")}
            });
    return categories;
  } on DioError catch (e) {
    print(e);
  }
  return categories;
}

deletecategory(idCategory) async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  try {
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer ${prefs.getString("token")}";
    return await dio
        .delete(
          '${url}categories?idCategory=${idCategory}',
        )
        .then((value) => {
              print(value),
            });
  } on DioError catch (e) {
    print(e);
  }
}

updateCategory(idCategory, newVal) async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  try {
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer ${prefs.getString("token")}";
    return await dio.post(
      '${url}categories/${idCategory}',
      data: {"name": newVal},
    );
  } catch (e) {}
}

addCategory(value) async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  try {
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer ${prefs.getString("token")}";
    return await dio.post(
      '${url}categories',
      data: {"name": value},
    );
  } catch (e) {}
}

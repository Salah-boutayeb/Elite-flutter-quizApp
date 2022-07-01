import 'package:dio/dio.dart';

class Category {
  var name;
  Category({this.name});
}

Future<List<Category>> getcategories() async {
  Dio dio = new Dio();
  List<Category> categories = [];

  try {
    await dio
        .get(
          'http://192.168.1.14:5555/api/categories',
        )
        .then((value) => {
              print(value),
              for (var category in value.data)
                {
                  {
                    print(category['name']),
                    categories.add(
                      new Category(
                        name: category['name'],
                      ),
                    )
                  }
                }
            });
    return categories;
  } on DioError catch (e) {
    print(e);
  }
  return categories;
}

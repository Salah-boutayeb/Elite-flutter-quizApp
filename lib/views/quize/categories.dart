import 'package:flutter/material.dart';
import 'package:flutter_ui_login/models/categoryModel.dart';

class Categories extends StatefulWidget {
  const Categories({Key key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Future<List<Category>> categories;

  initState() {
    super.initState();

    categories = getcategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder<List<Category>>(
          future: categories,
          builder: ((
            context,
            snapshot,
          ) {
            if (snapshot.hasData) {
              return Center(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(
                    5,
                    (index) {
                      return Center(
                        child: Text(
                          snapshot.data[index].name,
                        ),
                      );
                    },
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return CircularProgressIndicator();
            }
          }),
        ),
      ),
    );
  }
}

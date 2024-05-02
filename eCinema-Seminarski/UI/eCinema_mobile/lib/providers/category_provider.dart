import 'dart:convert';

import '../helpers/constants.dart';
import '../models/category.dart';
import '../utils/authorization.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class CategoryProvider extends BaseProvider<Category> {
  CategoryProvider() : super('Category/GetPaged');

  List<Category> categories = <Category>[];

  @override
  Future<List<Category>> get(Map<String, String>? params) async {
    categories = await super.get(params);
    return categories;
  }

  Future<List<Category>> getPaged() async {
    var uri = Uri.parse('$apiUrl/Category/GetPaged');
    var headers = Authorization.createHeaders();
    final Map<String, String> queryParameters = {};

    var isDisplayed = true;
    var includeMoviesWithData = false;
    queryParameters['IsDisplayed'] = isDisplayed.toString();
    queryParameters['IncludeMoviesWithData'] = includeMoviesWithData.toString();

    uri = uri.replace(queryParameters: queryParameters);
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var items = data['items'];
      return items.map((d) => fromJson(d)).cast<Category>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Category fromJson(data) {
    return Category.fromJson(data);
  }
}

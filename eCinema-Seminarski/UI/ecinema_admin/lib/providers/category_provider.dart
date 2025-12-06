import 'dart:convert';
import 'package:ecinema_admin/models/category.dart';
import '../helpers/constants.dart';
import '../models/searchObject/category_search.dart';
import '../utils/authorzation.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class CategoryProvider extends BaseProvider<Category> {
  CategoryProvider() : super('Category/GetPaged');

  Future<List<Category>> getPaged({CategorySerchObject? searchObject}) async {
    var uri = Uri.parse('$apiUrl/Category/GetPaged');
    var headers = Authorization.createHeaders();
    final Map<String, String> queryParameters = {};

    if (searchObject != null) {
      if (searchObject.pageNumber != null) {
        queryParameters['pageNumber'] = searchObject.pageNumber.toString();
      }
      if (searchObject.pageSize != null) {
        queryParameters['pageSize'] = searchObject.pageSize.toString();
      }
    }

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

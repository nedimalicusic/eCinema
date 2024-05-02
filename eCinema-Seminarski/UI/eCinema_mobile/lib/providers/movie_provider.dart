import 'dart:convert';
import 'package:ecinema_mobile/models/category_movies.dart';
import 'package:ecinema_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import '../helpers/constants.dart';
import '../models/category.dart';
import '../models/movie.dart';
import '../models/searchObject/movie_search.dart';
import '../utils/authorization.dart';

class MovieProvider extends BaseProvider<Movie> {
  MovieProvider() : super('Movie/GetPaged');

  Category? _selectedCategory;

  Future<List<Movie>> recommend(int userId) async {
    var uri = Uri.parse('$apiUrl/Movie/Recommendation/$userId');

    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return data.map((d) => fromJson(d)).cast<Movie>().toList();
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<CategoryMovies>> getCategoryAndMovies() async {
    var uri = Uri.parse('$apiUrl/Movie/GetCategoryAndMovies');
    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map<CategoryMovies>((json) => CategoryMovies.fromJson(json))
          .toList();
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<Movie>> getPaged({MovieSearchObject? searchObject}) async {
    var uri = Uri.parse('$apiUrl/Movie/GetPaged');
    var headers = Authorization.createHeaders();
    final Map<String, String> queryParameters = {};

    if (searchObject != null) {
      if (searchObject.name != null) {
        queryParameters['name'] = searchObject.name!;
      }
      if (searchObject.categoryId != null) {
        queryParameters['categoryId'] = searchObject.categoryId.toString();
      }
      if (searchObject.genreId != null) {
        queryParameters['genreId'] = searchObject.genreId.toString();
      }
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
      return items.map((d) => fromJson(d)).cast<Movie>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  setCategory(Category? category) {
    _selectedCategory = category;
  }

  Category? get category => _selectedCategory;

  @override
  Movie fromJson(data) {
    return Movie.fromJson(data);
  }
}

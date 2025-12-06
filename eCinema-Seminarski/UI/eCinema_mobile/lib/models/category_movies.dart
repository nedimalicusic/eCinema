import 'package:ecinema_mobile/models/category.dart';
import 'package:ecinema_mobile/models/movie.dart';

class CategoryMovies {
  final Category category;
  final List<Movie> movies;

  const CategoryMovies({
    required this.category,
    required this.movies,
  });

  factory CategoryMovies.fromJson(Map<String, dynamic> json) {
    return CategoryMovies(
      category: Category.fromJson(json['category']),
      movies: (json['movies'] as List<dynamic>).map((movieJson) => Movie.fromJson(movieJson)).toList(),
    );
  }
}

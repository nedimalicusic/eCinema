import 'package:ecinema_mobile/models/actors.dart';
import 'package:ecinema_mobile/models/category.dart';
import 'package:ecinema_mobile/models/genre.dart';
import 'package:ecinema_mobile/models/language.dart';
import 'package:ecinema_mobile/models/photo.dart';
import 'package:ecinema_mobile/models/production.dart';

class Movie {
  int id;
  String title;
  int duration;
  String description;
  String author;
  int releaseYear;
  int? photoId;
  Photo? photo;
  int productionId;
  Production production;
  Language language;
  int languageId;
  List<Category> categories;
  List<Genre> genres;
  List<Actors> actors;
  int? userRating;

  late bool isSelected = false;

  Movie({
    required this.id,
    required this.title,
    required this.duration,
    required this.description,
    required this.author,
    required this.releaseYear,
    this.photoId,
    this.photo,
    required this.categories,
    required this.genres,
    required this.actors,
    required this.language,
    required this.productionId,
    required this.languageId,
    required this.production,
    this.userRating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      duration: json['duration'],
      photo: json['photo'] != null ? Photo.fromJson(json['photo']) : null,
      description: json['description'],
      author: json['author'],
      releaseYear: json['releaseYear'],
      photoId: json['photoId'],
      categories: (json['categories'] as List<dynamic>).map((categoryJson) => Category.fromJson(categoryJson)).toList(),
      genres: (json['genres'] as List<dynamic>).map((genreJson) => Genre.fromJson(genreJson)).toList(),
      actors: (json['actors'] as List<dynamic>).map((actorJson) => Actors.fromJson(actorJson)).toList(),
      productionId: json['productionId'],
      languageId: json['languageId'],
      production: Production.fromJson(json['production']),
      language: Language.fromJson(json['language']),
      userRating: json['userRating'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['duration'] = duration;
    data['photo'] = photo;
    data['description'] = description;
    data['author'] = author;
    data['releaseYear'] = releaseYear;
    data['photoId'] = photoId;
    data['categories'] = categories;
    data['genres'] = genres;
    data['actors'] = actors;
    data['productionId'] = productionId;
    data['production'] = production;
    data['languageId'] = languageId;
    data['language'] = language;
    return data;
  }
}

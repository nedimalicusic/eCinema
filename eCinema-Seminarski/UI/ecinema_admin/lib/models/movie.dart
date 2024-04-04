import 'package:ecinema_admin/models/actor.dart';
import 'package:ecinema_admin/models/category.dart';
import 'package:ecinema_admin/models/genre.dart';
import 'package:ecinema_admin/models/language.dart';
import 'package:ecinema_admin/models/photo.dart';
import 'package:ecinema_admin/models/production.dart';

class Movie {
  int id;
  String title;
  int duration;
  String description;
  String author;
  int releaseYear;
  int numberOfViews;
  int photoId;
  Photo photo;
  int productionId;
  Production production;
  Language language;
  int languageId;
  List<Category> categories;
  List<Genre> genres;
  List<Actor> actors;
  late bool isSelected = false;

  Movie({
    required this.id,
    required this.title,
    required this.duration,
    required this.description,
    required this.author,
    required this.releaseYear,
    required this.numberOfViews,
    required this.photoId,
    required this.photo,
    required this.categories,
    required this.genres,
    required this.actors,
    required this.language,
    required this.productionId,
    required this.languageId,
    required this.production,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      duration: json['duration'],
      photo: Photo.fromJson(json['photo']),
      description: json['description'],
      author: json['author'],
      releaseYear: json['releaseYear'],
      numberOfViews: json['numberOfViews'],
      photoId: json['photoId'],
      categories: (json['categories'] as List<dynamic>)
          .map((categoryJson) => Category.fromJson(categoryJson))
          .toList(),
      genres: (json['genres'] as List<dynamic>)
          .map((genreJson) => Genre.fromJson(genreJson))
          .toList(),
      actors: (json['actors'] as List<dynamic>)
          .map((actorJson) => Actor.fromJson(actorJson))
          .toList(),
      productionId: json['productionId'],
      languageId: json['languageId'],
      production: Production.fromJson(json['production']),
      language: Language.fromJson(json['language']),
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
    data['numberOfViews'] = numberOfViews;
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

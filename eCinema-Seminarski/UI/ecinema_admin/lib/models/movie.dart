import 'package:ecinema_admin/models/actor.dart';
import 'package:ecinema_admin/models/category.dart';
import 'package:ecinema_admin/models/genre.dart';
import 'package:ecinema_admin/models/language.dart';
import 'package:ecinema_admin/models/photo.dart';
import 'package:ecinema_admin/models/production.dart';

class Movie {
  late int id;
  late String title;
  late int duration;
  late String description;
  late String author;
  late int? releaseYear;
  late int? photoId;
  late Photo? photo;
  late int? productionId;
  late Production? production;
  late Language language;
  late int languageId;
  late List<Category>? categories;
  late List<Genre>? genres;
  late List<Actor> actors;
  late bool isSelected = false;

  Movie({
    required this.id,
    required this.title,
    required this.duration,
    required this.description,
    required this.author,
    this.releaseYear,
    this.photoId,
    this.photo,
    this.categories,
    this.genres,
    required this.actors,
    required this.language,
    this.productionId,
    required this.languageId,
    required this.production,
  });

  Movie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author = json['author'];
    title = json['title'];
    duration = json['duration'];
    if (json['photo'] != null) {
      photo = Photo.fromJson(json['photo']);
    } else {
      photo = null;
    }
    description = json['description'];
    author = json['author'];
    releaseYear = json['releaseYear'];
    photoId = json['photoId'];
    if (json['categories'] != null) {
      categories = (json['categories'] as List<dynamic>)
          .map((categoryJson) => Category.fromJson(categoryJson))
          .toList();
    } else {
      categories = null;
    }
    if (json['genres'] != null) {
      genres = (json['genres'] as List<dynamic>)
          .map((genreJson) => Genre.fromJson(genreJson))
          .toList();
    } else {
      genres = null;
    }

    if (json['actors'] != null) {
      actors = (json['actors'] as List<dynamic>)
          .map((actorJson) => Actor.fromJson(actorJson))
          .toList();
    } else {
      genres = null;
    }

    productionId = json['productionId'];
    languageId = json['languageId'];
    if (json['production'] != null) {
      production = Production.fromJson(json['production']);
    } else {
      production = null;
    }
    if (json['language'] != null) {
      language = Language.fromJson(json['production']);
    } else {
      production = null;
    }
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

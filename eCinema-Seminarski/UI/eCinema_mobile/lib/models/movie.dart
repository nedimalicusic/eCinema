import 'package:ecinema_mobile/models/photo.dart';
import 'package:ecinema_mobile/models/production.dart';

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
  int languageId;
  Production production;
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
      productionId: json['productionId'],
      languageId: json['languageId'],
      production: Production.fromJson(json['production']),
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
    data['productionId'] = productionId;
    data['production'] = production;
    data['languageId'] = languageId;
    return data;
  }
}

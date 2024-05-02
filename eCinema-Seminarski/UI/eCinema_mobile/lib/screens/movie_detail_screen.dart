// ignore_for_file: non_constant_identifier_names

import 'package:ecinema_mobile/widgets/shows_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../helpers/constants.dart';
import '../models/movie.dart';
import '../providers/photo_provider.dart';
import '../utils/authorization.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});
  static const String routeName = '/movieDetail';

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late PhotoProvider _photoProvider;

  @override
  void initState() {
    super.initState();
    _photoProvider = context.read<PhotoProvider>();
  }

  Future<String> loadPhoto(String guidId) async {
    return await _photoProvider.getPhoto(guidId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movie details',
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhotoWidget(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 25.0),
              child: Text(
                widget.movie.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
                  child: Text(
                    'Genres:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Wrap(
                    spacing: 5.0,
                    children: widget.movie.genres
                        .map((genre) => Chip(label: Text(genre.name)))
                        .toList(),
                  ),
                ),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
                  child: Text(
                    'Categories:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Wrap(
                    spacing: 5.0,
                    children: widget.movie.categories
                        .map((category) => Chip(label: Text(category.name)))
                        .toList(),
                  ),
                ),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
                  child: Text(
                    'Actors:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Wrap(
                    spacing: 5.0,
                    children: widget.movie.actors
                        .map(
                          (actor) => Chip(
                            label: Text('${actor.firstName} ${actor.lastName}'),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
                  child: Text(
                    'Description:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    widget.movie.description,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            ShowsTab(movieId: widget.movie.id),
          ],
        ),
      ),
    );
  }

  Widget PhotoWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                margin: const EdgeInsets.only(right: 20),
                width: 210,
                height: 270,
                child: widget.movie.photo.guidId != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: NetworkImage(
                            '$apiUrl/Photo/GetById?id=${widget.movie.photo.guidId}&original=true',
                            headers: Authorization.createHeaders(),
                          ),
                          fadeInDuration: const Duration(milliseconds: 300),
                          fit: BoxFit.fill,
                        ),
                      )
                    : const Placeholder(),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InfoCard(
                    widget.movie.language.name.toString(),
                    "Language",
                    Icons.play_arrow_rounded,
                  ),
                  InfoCard(
                    widget.movie.duration.toString(),
                    "Duration",
                    Icons.timer,
                  ),
                  InfoCardWithoutIcon(
                    widget.movie.production.country.abbreviation,
                    widget.movie.releaseYear.toString(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget InfoCard(String text, String text2, IconData icon) {
    return Card(
      elevation: 4,
      color: Colors.teal,
      child: Container(
        height: 80,
        width: 90,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              size: 26,
              color: Colors.white,
            ),
            const SizedBox(height: 3),
            Text(
              text2,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(height: 3),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget InfoCardWithoutIcon(String country, String year) {
    return Card(
      elevation: 4,
      color: Colors.teal,
      child: Container(
        height: 80,
        width: 90,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Text(
              "Country",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              country,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const Text(
              "Year",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              year,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

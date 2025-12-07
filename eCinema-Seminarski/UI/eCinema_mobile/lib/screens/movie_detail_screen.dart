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
        title: const Text('Movie details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildTitle(),
            _buildGenres(),
            _buildCategories(),
            _buildActors(),
            _buildDescription(),
            ShowsTab(movieId: widget.movie.id),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            width: 200,
            height: 280,
            child: widget.movie.photo?.guidId != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: NetworkImage(
                        '$apiUrl/Photo/GetById?id=${widget.movie.photo?.guidId}&original=true',
                        headers: Authorization.createHeaders(),
                      ),
                      fadeInDuration: const Duration(milliseconds: 300),
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    'assets/images/nophoto.jpg',
                    fit: BoxFit.fill,
                  ),
          ),
          Expanded(
            child: Column(
              children: [
                InfoCard(
                  widget.movie.language.name.toString(),
                  "Language",
                  Icons.play_arrow_rounded,
                ),
                const SizedBox(height: 3),
                InfoCard(
                  widget.movie.duration.toString(),
                  "Duration",
                  Icons.timer,
                ),
                const SizedBox(height: 3),
                InfoCardWithoutIcon(
                  widget.movie.production.country.abbreviation,
                  widget.movie.releaseYear.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25.0),
      child: Text(
        widget.movie.title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildGenres() {
    return _buildChipSection(
      title: "Genres",
      items: widget.movie.genres.map((e) => e.name).toList(),
    );
  }

  Widget _buildCategories() {
    return _buildChipSection(
      title: "Categories",
      items: widget.movie.categories.map((e) => e.name).toList(),
    );
  }

  Widget _buildActors() {
    return _buildChipSection(
      title: "Actors",
      items: widget.movie.actors
          .map((a) => '${a.firstName} ${a.lastName}')
          .toList(),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            widget.movie.description,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildChipSection(
      {required String title, required List<String> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title:',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6.0,
            runSpacing: 4.0,
            children: items.map((text) => Chip(label: Text(text))).toList(),
          ),
        ],
      ),
    );
  }

  Widget InfoCard(String text, String text2, IconData icon) {
    return Card(
      elevation: 3,
      color: Colors.teal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 26, color: Colors.white),
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
      elevation: 3,
      color: Colors.teal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Country",
                style: TextStyle(color: Colors.white, fontSize: 12)),
            Text(
              country,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            const Text("Year",
                style: TextStyle(color: Colors.white, fontSize: 12)),
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

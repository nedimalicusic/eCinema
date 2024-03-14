// ignore_for_file: non_constant_identifier_names

import 'package:ecinema_mobile/models/shows.dart';
import 'package:ecinema_mobile/screens/seats_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../providers/photo_provider.dart';
import '../utils/authorization.dart';

class MovieDetailScreen extends StatefulWidget {
  final Shows shows;
  const MovieDetailScreen({super.key, required this.shows});
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PhotoWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30.0),
            child: Text(
              widget.shows.movie.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
            child: Text(
              widget.shows.movie.description,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const Spacer(),
          Center(
              child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 400,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, SeatsScreen.routeName,
                          arguments: widget.shows);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Make reservation')
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget PhotoWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<String>(
              future: loadPhoto(widget.shows.movie.photo.guidId ?? ''),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Greška prilikom učitavanja slike');
                } else {
                  final imageUrl = snapshot.data;

                  if (imageUrl != null && imageUrl.isNotEmpty) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: FadeInImage(
                        image: NetworkImage(
                          imageUrl,
                          headers: Authorization.createHeaders(),
                        ),
                        placeholder: MemoryImage(kTransparentImage),
                        fadeInDuration: const Duration(milliseconds: 300),
                        fit: BoxFit.fill,
                        height: 280,
                        width: 210,
                      ),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Image.asset(
                        'assets/images/user2.png',
                        height: 280,
                        width: 210,
                        fit: BoxFit.fill,
                      ),
                    );
                  }
                }
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InfoCard(
                    widget.shows.movie.releaseYear.toString(),
                    "Genre",
                    Icons.play_arrow_rounded,
                  ),
                  InfoCard(
                    widget.shows.movie.duration.toString(),
                    "Duration",
                    Icons.timer,
                  ),
                  InfoCardWithoutIcon(
                    widget.shows.movie.production.country.abbreviation,
                    widget.shows.movie.releaseYear.toString(),
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
        width: 80,
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
        width: 80,
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

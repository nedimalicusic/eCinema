import 'package:ecinema_mobile/models/shows.dart';
import 'package:ecinema_mobile/providers/show_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/genre.dart';
import '../providers/genre_provider.dart';
import '../providers/photo_provider.dart';
import '../utils/authorization.dart';
import '../utils/error_dialog.dart';
import 'movie_detail_screen.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({Key? key}) : super(key: key);

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late GenreProvider _genreProvider;
  late ShowProvider _showProvider;
  late PhotoProvider _photoProvider;
  List<Genre> genres = <Genre>[];
  List<Shows> shows = <Shows>[];
  int? selectedGenre;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _showProvider = context.read<ShowProvider>();
    _genreProvider = context.read<GenreProvider>();
    _photoProvider = context.read<PhotoProvider>();
    loadData();
  }

  void loadData() async {
    loadGenres();
    loadShows();
  }

  Future loadGenres() async {
    try {
      var data = await _genreProvider.get(null);
      setState(() {
        genres = data;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadShows() async {
    loading = true;
    try {
      var data = await _showProvider.getByGenreId(selectedGenre, 1);
      setState(() {
        shows = data;
      });
      loading = false;
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadMostWatchedShows() async {
    loading = true;
    try {
      var data = await _showProvider.getMostWatchedShows(9999, 1);
      setState(() {
        shows = data;
      });
      loading = false;
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadLastAddShows() async {
    loading = true;
    try {
      var data = await _showProvider.getLastAddShows(9999, 1);
      setState(() {
        shows = data;
      });
      loading = false;
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  Future<String> loadPhoto(String guidId) async {
    return await _photoProvider.getPhoto(guidId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Filmovi"),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: const Text("Najgledaniji filmovi"),
                onTap: () {
                  loadMostWatchedShows();
                },
              ),
              ListTile(
                title: const Text("Posljednje dodani filmovi"),
                onTap: () {
                  loadLastAddShows();
                },
              ),
              ...genres.map((e) => ListTile(
                    title: Text(e.name),
                    onTap: () {
                      setState(() {
                        selectedGenre = e.id;
                      });
                      loadShows();
                    },
                  )),
            ],
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 5.0),
            _buildShowList(shows),
          ],
        ));
  }

  Widget _buildShowList(List<Shows> shows) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
        ),
        padding: const EdgeInsets.all(4.0),
        itemCount: shows.length,
        itemBuilder: (context, index) {
          return _buildShow(context, shows[index]);
        },
      ),
    );
  }

  Widget _buildShow(BuildContext context, Shows shows) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        MovieDetailScreen.routeName,
        arguments: shows,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder<String>(
          future: loadPhoto(shows.movie.photo.guidId ?? ''),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                value: 16,
              ));
            } else if (snapshot.hasError) {
              return const Text('Greška prilikom učitavanja slike');
            } else {
              final imageUrl = snapshot.data;

              if (imageUrl != null && imageUrl.isNotEmpty) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage(
                    image: NetworkImage(
                      imageUrl,
                      headers: Authorization.createHeaders(),
                    ),
                    placeholder: MemoryImage(kTransparentImage),
                    fadeInDuration: const Duration(milliseconds: 300),
                    fit: BoxFit.fill,
                    width: 80,
                    height: 105,
                  ),
                );
              } else {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.asset(
                    'assets/images/user2.png',
                    width: 80,
                    height: 105,
                    fit: BoxFit.fill,
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}

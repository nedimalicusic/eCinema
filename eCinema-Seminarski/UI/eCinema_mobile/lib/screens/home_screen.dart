import 'package:ecinema_mobile/models/cinema.dart';
import 'package:ecinema_mobile/models/shows.dart';
import 'package:ecinema_mobile/providers/cinema_provider.dart';
import 'package:ecinema_mobile/providers/show_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../providers/photo_provider.dart';
import '../utils/authorization.dart';
import '../utils/error_dialog.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;
  late ShowProvider _showProvider;
  late CinemaProvider _cinemaProvider;
  List<Shows> showMostWatched = <Shows>[];
  List<Shows> showLastAdd = <Shows>[];
  late PhotoProvider _photoProvider;

  late Cinema cinema;
  @override
  void initState() {
    super.initState();
    _showProvider = context.read<ShowProvider>();
    _cinemaProvider = context.read<CinemaProvider>();
    _photoProvider = context.read<PhotoProvider>();
    cinema = _cinemaProvider.getSelectCinema();
    loadLastAddShows();
    loadMostWatchedShows();
  }

  void loadLastAddShows() async {
    loading = true;
    try {
      var data = await _showProvider.getLastAddShows(3, 1);
      setState(() {
        showLastAdd = data;
      });
      loading = false;
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadMostWatchedShows() async {
    loading = true;
    try {
      var data = await _showProvider.getMostWatchedShows(3, 1);
      setState(() {
        showMostWatched = data;
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
          centerTitle: true,
          title: Text(
            cinema.name.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Search",
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.teal),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.teal),
                    ),
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Najgledaniji filmovi",
              style: TextStyle(
                fontSize: 20,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildShowList(showMostWatched),
            const Text(
              "Posljednje dodani filmovi",
              style: TextStyle(
                fontSize: 20,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildShowList(showLastAdd)
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
        padding: const EdgeInsets.all(8),
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

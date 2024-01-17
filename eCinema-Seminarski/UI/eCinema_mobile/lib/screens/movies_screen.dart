import 'package:ecinema_mobile/models/shows.dart';
import 'package:ecinema_mobile/providers/show_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../helpers/constants.dart';
import '../models/genre.dart';
import '../providers/genre_provider.dart';
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
  List<Genre> genres = <Genre>[];
  List<Shows> shows = <Shows>[];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? selectedGenre;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _showProvider = context.read<ShowProvider>();
    _genreProvider = context.read<GenreProvider>();
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
      var data = await _showProvider.getByGenreId(selectedGenre,1);
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
      var data = await _showProvider.getMostWatchedShows(9999,1);
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
      var data = await _showProvider.getLastAddShows(9999,1);
      setState(() {
        shows = data;
      });
      loading = false;
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filmovi"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text("Najgledaniji filmovi"),
              onTap: () {
                loadMostWatchedShows();
              },
            ),
            ListTile(
              title: Text("Posljednje dodani filmovi"),
              onTap: () {
                loadLastAddShows();
              },
            ),
            Divider(),
            ...genres.map((e) =>
                ListTile(
                  title: Text(e.name),
                  onTap: () {
                    setState(() {
                      selectedGenre = e.id;
                    });
                    loadShows();
                    // Handle onTap action
                  },
                )),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          _buildShowList(shows)
        ],
      )
    );
  }

  Widget _buildShowList(List<Shows> shows) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
      child: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded( // Dodajte Expanded oko slike
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child:FadeInImage(
                  image: NetworkImage(
                    '$apiUrl/images/${shows.movie.photoId}',
                    headers: Authorization.createHeaders(),
                  ),
                  placeholder: MemoryImage(kTransparentImage),
                  fadeInDuration: const Duration(milliseconds: 300),
                  fit: BoxFit.fill,
                  width: 80,
                  height: 105,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
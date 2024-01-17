import 'package:ecinema_mobile/models/shows.dart';
import 'package:ecinema_mobile/providers/show_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';
import '../providers/movie_provider.dart';
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
  List<Shows> showMostWatched = <Shows>[];
  List<Shows> showLastAdd = <Shows>[];

  @override
  void initState() {
    super.initState();
    _showProvider = context.read<ShowProvider>();
    loadLastAddShows();
    loadMostWatchedShows();
  }
  void loadLastAddShows() async {
    loading = true;
    try {
      var data = await _showProvider.getLastAddShows(3,1);
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
      var data = await _showProvider.getMostWatchedShows(3,1);
      setState(() {
        showMostWatched = data;
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
          title: Text("Home"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Search",
                  border: InputBorder.none, // Uklanja podrazumijevanu granicu
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.teal), // Boja granice kad nije u fokusu
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.teal), // Boja granice kad je u fokusu
                  ),
                ),
              )
            ),
            SizedBox(height: 20,),
            Text(
              "Najgledaniji filmovi",
              style: TextStyle(
                fontSize: 20,
                color: Colors.teal,// Postavite željenu veličinu fonta ovdje
                fontWeight: FontWeight.bold, // Možete dodati i težinu fonta ako želite
              ),
            ),
            SizedBox(height: 10),
            _buildShowList(showMostWatched),
            Text(
              "Posljednje dodani filmovi",
              style: TextStyle(
                fontSize: 20,
                color: Colors.teal,// Postavite željenu veličinu fonta ovdje
                fontWeight: FontWeight.bold, // Možete dodati i težinu fonta ako želite
              ),
            ),
            SizedBox(height: 10),
            _buildShowList(showLastAdd)
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
                child: Image.network(
                  'https://localhost:44320/api/Photo/${shows.movie.photoId}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

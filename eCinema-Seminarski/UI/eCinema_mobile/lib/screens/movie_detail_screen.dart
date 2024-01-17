import 'package:ecinema_mobile/screens/seats_screen.dart';
import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../models/shows.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key, required this.shows});

  static const String routeName = '/movieDetail';
  final Shows shows;

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.network('https://picsum.photos/250?image=${widget.shows.movie.photoId}',
                          fit: BoxFit.cover,
                          height: 280,
                          width: 210,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InfoCard(widget.shows.movie.releaseYear.toString(),"Genre", Icons.play_arrow_rounded),
                          InfoCard(widget.shows.movie.duration.toString(),"Duration" ,Icons.timer),
                          InfoCardWithoutIcon(widget.shows.movie.production.country.abbreviation,widget.shows.movie.releaseYear.toString()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 10, horizontal: 40.0),
              child: Text(
                  widget.shows.movie.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40.0),
              child: Text(widget.shows.movie.description, style: TextStyle(fontSize: 18)),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: SizedBox(
                width: 400,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      SeatsScreen.routeName,
                      arguments: widget.shows
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(width: 10),
                      Text('Make reservation'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget InfoCard(String text,String text2,IconData icon)
  {
    return Card(
        elevation: 4,
        color: Colors.teal,
        child: Container(
            height: 80,
            width: 80,
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Icon(icon,       // Added Icon
                    size: 26,
                  color: Colors.white,
                ),
                SizedBox(height: 3),
                Text(text2,style: TextStyle(color: Colors.white,fontSize: 12),),
                SizedBox(height: 3),    // Added SizeBox
                Text(text,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),),
              ],
            )
        )
    );
  }

  Widget InfoCardWithoutIcon(String country,String year)
  {
    return Card(
        elevation: 4,
        color: Colors.teal,
        child: Container(
            height: 80,
            width: 80,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text("Country",style: TextStyle(color: Colors.white,fontSize: 12),),
                Text(country,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),),
                Text("Year",style: TextStyle(color: Colors.white,fontSize: 12),),
                Text(year,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),),
              ],
            )
        )
    );
  }
}

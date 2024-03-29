import 'package:ecinema_mobile/providers/cinema_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cinema.dart';
import '../utils/error_dialog.dart';

class CinemaScreen extends StatefulWidget {
  const CinemaScreen({Key? key}) : super(key: key);

  static const routeName = '/cinema';

  @override
  State<CinemaScreen> createState() => _CinemaScreenState();
}

class _CinemaScreenState extends State<CinemaScreen> {
  List<Cinema> cinemas = <Cinema>[];
  late CinemaProvider _cinemaProvider;

  @override
  void initState() {
    super.initState();
    _cinemaProvider = context.read<CinemaProvider>();
    loadCinema();
  }

  void loadCinema() async {
    try {
      var cinemasResponse = await _cinemaProvider.get(null);
      setState(() {
        cinemas = cinemasResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          const Text(
            "Odaberite kino",
            style: TextStyle(
                fontSize: 20, color: Colors.teal, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(child: _buildCinemaList(cinemas))
        ],
      ),
    ));
  }

  Widget _buildCinemaList(List<Cinema> cinemas) {
    return ListView.builder(
      itemCount: cinemas.length,
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(height: 10),
            _buildCinema(context, cinemas[index]),
            const SizedBox(height: 5),
          ],
        );
      },
    );
  }

  Widget _buildCinema(BuildContext context, Cinema cinema) {
    return SizedBox(
      height: 55,
      width: 350,
      child: ElevatedButton(
        onPressed: () {
          _cinemaProvider.setSelectedCinema(cinema);
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        },
        child: Text(cinema.name),
      ),
    );
  }
}

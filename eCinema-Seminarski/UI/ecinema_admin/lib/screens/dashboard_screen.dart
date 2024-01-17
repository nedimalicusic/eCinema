import 'package:ecinema_admin/models/dashboard.dart';
import 'package:ecinema_admin/providers/cinema_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cinema.dart';
import '../utils/error_dialog.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Dashboard dashboard = Dashboard(
      countUsers: 0,
      countUsersActive: 0,
      countUsersInActive: 0,
      countEmployees: 0,
      countOfReservation: 0);
  late CinemaProvider _cinemaProvider;
  List<Cinema> cinemaList = <Cinema>[];
  int? selectedCinema;

  @override
  void initState() {
    super.initState();
    _cinemaProvider = context.read<CinemaProvider>();
    loadDashboardInformation(1);
    loadCinemas();
  }

  void loadDashboardInformation(int cinemaId) async {
    try {
      var dashboardResponse =
          await _cinemaProvider.getDashboardInformation(cinemaId);
      setState(() {
        dashboard = dashboardResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadCinemas() async {
    try {
      var cinemasResponse = await _cinemaProvider.get(null);
      setState(() {
        cinemaList = cinemasResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 500,
            child: Padding(
              padding: const EdgeInsets.only(left: 136, top: 8, right: 8),
              child: DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white70,
                  hintText: 'Izaberite kino',
                ),
                value: selectedCinema,
                items: cinemaList.map((Cinema cinema) {
                  return DropdownMenuItem<int>(
                    value: cinema.id,
                    child: Text(cinema.name),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedCinema = newValue;
                  });
                  loadDashboardInformation(selectedCinema!);
                },
              ),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildInfoContainer("Broj korisnika", dashboard.countUsers),
                    _buildInfoContainer(
                        "Aktivni korisnici", dashboard.countUsersActive),
                    _buildInfoContainer(
                        "Neaktivni korisnici", dashboard.countUsersInActive),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildInfoContainer(
                        "Rezervacije", dashboard.countOfReservation),
                    _buildInfoContainer(
                        "Broj zaposlenika", dashboard.countEmployees),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoContainer(String label, int value) {
    return Container(
      width: 300,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value.toString(),
            style: const TextStyle(
                color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

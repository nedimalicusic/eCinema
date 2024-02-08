// ignore_for_file: non_constant_identifier_names

import 'package:ecinema_admin/models/dashboard.dart';
import 'package:ecinema_admin/providers/cinema_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  Cinema? selectedCinema;

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
      if (mounted) {
        setState(() {
          dashboard = dashboardResponse;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadCinemas() async {
    try {
      var cinemasResponse = await _cinemaProvider.get(null);
      if (mounted) {
        setState(() {
          cinemaList = cinemasResponse;
        });
      }
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: buildFilterDropdowns(),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          StatsBuilder(
                            "assets/icons/users1.svg",
                            "Ukupan broj korisnika",
                            dashboard.countUsers,
                          ),
                          const SizedBox(width: 14),
                          StatsBuilder(
                            "assets/icons/activeUser.svg",
                            "Aktivni korisnici",
                            dashboard.countUsersActive,
                          ),
                          const SizedBox(width: 14),
                          StatsBuilder(
                            "assets/icons/unactiveUser.svg",
                            "Neaktivni korisnici",
                            dashboard.countUsersInActive,
                          ),
                          const SizedBox(width: 14),
                          StatsBuilder(
                            "assets/icons/calendar.svg",
                            "Broj rezervacija",
                            dashboard.countOfReservation,
                          ),
                          const SizedBox(width: 14),
                          StatsBuilder(
                            "assets/icons/users1.svg",
                            "Broj zaposlenika",
                            dashboard.countEmployees,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded StatsBuilder(String icon, String label, int num) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.teal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 35,
              color: Colors.white,
            ),
            const SizedBox(height: 5),
            Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            Text(
              num.toString(),
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Row buildFilterDropdowns() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('  Pretraga po kinima:'),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DropdownButton<Cinema>(
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  value: selectedCinema,
                  items: [
                    const DropdownMenuItem<Cinema>(
                      value: null,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('Svi'),
                      ),
                    ),
                    ...cinemaList.map((Cinema cinema) {
                      return DropdownMenuItem<Cinema>(
                        value: cinema,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(cinema.name),
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: (Cinema? newValue) {
                    setState(() {
                      selectedCinema = newValue;
                    });
                    if (selectedCinema == null) {
                      loadDashboardInformation(1);
                    } else {
                      loadDashboardInformation(selectedCinema!.id);
                    }
                  },
                  underline: const Text(""),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

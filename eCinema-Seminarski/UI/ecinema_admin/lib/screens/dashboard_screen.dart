// ignore_for_file: non_constant_identifier_names

import 'package:ecinema_admin/models/dashboard.dart';
import 'package:ecinema_admin/providers/cinema_provider.dart';
import 'package:ecinema_admin/providers/reservation_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../models/cinema.dart';
import '../models/searchObject/bar_chart_search.dart';
import '../providers/login_provider.dart';
import '../utils/error_dialog.dart';
import '../widgets/legend_widget.dart';

List<double> data = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
int currentYear = DateTime.now().year;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Dashboard dashboard = Dashboard(countUsers: 0, countUsersActive: 0, countUsersInActive: 0, countEmployees: 0, countOfReservation: 0);
  late CinemaProvider _cinemaProvider;
  late ReservationProvider _reservationProvider;
  List<Cinema> cinemaList = <Cinema>[];
  Cinema? selectedCinema;
  final cyclingColor = Colors.teal;
  late LoginProvider loginUserProvider;
  @override
  void initState() {
    super.initState();
    _cinemaProvider = context.read<CinemaProvider>();
    _reservationProvider = context.read<ReservationProvider>();
    loginUserProvider = context.read<LoginProvider>();
    loadCinemas();
    loadDashboardInformation(null);
    loadReservations(BarChartSearchObject(year: currentYear, cinemaId: null));
  }

  void loadDashboardInformation(int? cinemaId) async {
    try {
      var dashboardResponse = await _cinemaProvider.getDashboardInformation(cinemaId);
      if (mounted) {
        setState(() {
          dashboard = dashboardResponse;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadReservations(BarChartSearchObject searchObject) async {
    try {
      var response = await _reservationProvider.getByMonth(searchObject);
      if (mounted) {
        setState(() {
          data = response.map((value) => (value as num).toDouble()).toList();
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Dobrodošli, ${loginUserProvider.user!.firstName} ${loginUserProvider.user!.lastName}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 20),
              ],
            ),
          )
        ],
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
                            "Broj korisnika",
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
                      const SizedBox(height: 20),
                      buildReservationsBarChart(),
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

  Container buildReservationsBarChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.teal, width: 2.0),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SizedBox(
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: BarChartReservations(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentYear--;
                    });
                    loadReservations(BarChartSearchObject(year: currentYear, cinemaId: selectedCinema?.id));
                  },
                  icon: const Icon(Icons.arrow_left),
                  color: Colors.teal,
                ),
                const SizedBox(width: 8),
                Text(
                  currentYear.toString(),
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentYear++;
                    });
                    loadReservations(BarChartSearchObject(year: currentYear, cinemaId: selectedCinema?.id));
                  },
                  icon: const Icon(Icons.arrow_right),
                  color: Colors.teal,
                ),
              ],
            ),
          ],
        ),
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
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
            Text(
              num.toString(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
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
                      loadDashboardInformation(null);
                      loadReservations(BarChartSearchObject(year: currentYear, cinemaId: null));
                    } else {
                      loadDashboardInformation(selectedCinema!.id);
                      loadReservations(BarChartSearchObject(year: currentYear, cinemaId: selectedCinema == null ? null : selectedCinema!.id));
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

class BarChartReservations extends StatelessWidget {
  BarChartReservations({Key? key}) : super(key: key);

  final color = Colors.teal;
  final betweenSpace = 0.2;
  final maxData = data.isNotEmpty ? data.reduce((value, element) => value > element ? value : element) : 0.0;

  BarChartRodData generateRodData(
    double y,
    Color color,
  ) {
    return BarChartRodData(
      toY: y,
      color: color,
      width: 40,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(6),
        topRight: Radius.circular(6),
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'JAN';
        break;
      case 1:
        text = 'FEB';
        break;
      case 2:
        text = 'MAR';
        break;
      case 3:
        text = 'APR';
        break;
      case 4:
        text = 'MAY';
        break;
      case 5:
        text = 'JUN';
        break;
      case 6:
        text = 'JUL';
        break;
      case 7:
        text = 'AUG';
        break;
      case 8:
        text = 'SEP';
        break;
      case 9:
        text = 'OCT';
        break;
      case 10:
        text = 'NOV';
        break;
      case 11:
        text = 'DEC';
        break;
      default:
        text = '';
    }
    return Text(text, style: style);
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    return Text(value.toInt().toString(), style: style);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Broj rezervacija po mjesecu',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        LegendsListWidget(
          legends: [
            Legend('Broj rezervacija', color),
          ],
        ),
        SizedBox(
          height: 400,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceBetween,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: leftTitles,
                  ),
                ),
                rightTitles: AxisTitles(),
                topTitles: AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: bottomTitles,
                    reservedSize: 40,
                  ),
                ),
              ),
              barTouchData: BarTouchData(enabled: false),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: false),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barsSpace: 3,
                  barRods: [generateRodData(data[0], color)],
                ),
                BarChartGroupData(
                  x: 1,
                  barsSpace: 3,
                  barRods: [generateRodData(data[1], color)],
                ),
                BarChartGroupData(
                  x: 2,
                  barsSpace: 3,
                  barRods: [generateRodData(data[2], color)],
                ),
                BarChartGroupData(
                  x: 3,
                  barsSpace: 3,
                  barRods: [generateRodData(data[3], color)],
                ),
                BarChartGroupData(
                  x: 4,
                  barsSpace: 3,
                  barRods: [generateRodData(data[4], color)],
                ),
                BarChartGroupData(
                  x: 5,
                  barsSpace: 3,
                  barRods: [generateRodData(data[5], color)],
                ),
                BarChartGroupData(
                  x: 6,
                  barsSpace: 3,
                  barRods: [generateRodData(data[6], color)],
                ),
                BarChartGroupData(
                  x: 7,
                  barsSpace: 3,
                  barRods: [generateRodData(data[7], color)],
                ),
                BarChartGroupData(
                  x: 8,
                  barsSpace: 3,
                  barRods: [generateRodData(data[8], color)],
                ),
                BarChartGroupData(
                  x: 9,
                  barsSpace: 0,
                  barRods: [generateRodData(data[9], color)],
                ),
                BarChartGroupData(
                  x: 10,
                  barsSpace: 0,
                  barRods: [generateRodData(data[10], color)],
                ),
                BarChartGroupData(
                  x: 11,
                  barsSpace: 0,
                  barRods: [generateRodData(data[11], color)],
                ),
              ],
              maxY: maxData,
            ),
          ),
        ),
      ],
    );
  }
}

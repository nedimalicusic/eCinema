import 'package:collection/collection.dart';
import 'package:ecinema_mobile/extensions/date_only_compare.dart';
import 'package:ecinema_mobile/models/cinema.dart';
import 'package:ecinema_mobile/models/searchObject/show_search.dart';
import 'package:ecinema_mobile/providers/cinema_provider.dart';
import 'package:ecinema_mobile/providers/show_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/shows.dart';
import '../providers/date_provider.dart';
import '../screens/seats_screen.dart';
import 'date_selector.dart';

class ShowsTab extends StatefulWidget {
  final int movieId;
  const ShowsTab({super.key, required this.movieId});

  @override
  State<ShowsTab> createState() => _ShowsTabState();
}

class _ShowsTabState extends State<ShowsTab> {
  List<Shows> shows = <Shows>[];
  List<Cinema> cinemas = <Cinema>[];

  late DateProvider _dateProvider;
  late CinemaProvider _cinemaProvider;
  late ShowProvider _showProvider;

  Cinema? selectedCinema;
  late DateTime selectedDate;
  Shows? selectedShow;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    _dateProvider = context.read<DateProvider>();
    _cinemaProvider = context.read<CinemaProvider>();
    _showProvider = context.read<ShowProvider>();

    selectedDate = _dateProvider.selectedDate;

    loadData();
  }

  void loadData() async {
    await loadCinemas();
    loadShows();
  }

  void loadShows() async {
    if (selectedCinema == null) return;
    setState(() {
      loading = true;
    });
    var search = ShowSearchObject(
        movieId: widget.movieId,
        cinemaId: selectedCinema?.id,
        date: selectedDate);

    var data = await _showProvider.getPaged(searchObject: search);
    if (mounted) {
      setState(() {
        shows = data;
        loading = false;
      });
    }
  }

  Future loadCinemas() async {
    var data = await _cinemaProvider.get(null);

    if (mounted) {
      setState(() {
        selectedCinema = data.first;
        cinemas = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var date = context.watch<DateProvider>().selectedDate;
    if (selectedDate != date) {
      selectedDate = date;
      selectedShow = null;
      loadShows();
    }
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Datum',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () => _selectDate(context),
                child: const Icon(
                  Icons.calendar_today,
                  size: 26,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ),
        const DateSelector(),
        _buildCinemasDropdown(),
        Container(child: _buildProjectionTickets(context)),
        if (selectedShow != null)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  SeatsScreen.routeName,
                  arguments: selectedShow,
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.teal),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              child: const Text(
                'Rezervacija',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          )
      ],
    );
  }

  Widget _buildCinemasDropdown() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kino',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            cinemas.isNotEmpty
                ? DropdownButton<Cinema>(
                    isExpanded: true,
                    value: selectedCinema,
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    onChanged: (Cinema? value) {
                      setState(() {
                        selectedCinema = value;
                        selectedShow = null;
                      });
                      loadShows();
                    },
                    items: cinemas
                        .map<DropdownMenuItem<Cinema>>(
                            (l) => DropdownMenuItem<Cinema>(
                                  value: l,
                                  child: Text(l.name),
                                ))
                        .toList(),
                  )
                : Container(),
          ],
        ));
  }

  Widget _buildProjectionTickets(context) {
    var ticketColor = Colors.teal;
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.teal,
        ),
      );
    }
    // if (shows.isEmpty) {
    //   return const Text(
    //     'Prazno :(',
    //   );
    // }
    var groupedProjections = groupBy(shows, (Shows obj) => obj.showType.name);

    var groups = <Widget>[];
    groupedProjections.forEach(
      (key, value) {
        groups.add(Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                key.toString(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.teal,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            SizedBox(
              height: 90,
              child: GridView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                ),
                scrollDirection: Axis.horizontal,
                children: value
                    .map((p) => GestureDetector(
                          onTap: () => selectProjection(p),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'assets/images/ticket120.png',
                                color: selectedShow == p
                                    ? Colors.blue
                                    : ticketColor,
                              ),
                              Positioned(
                                top: 20,
                                child: Text(
                                  '${DateFormat('HH:mm').format(p.startsAt)}h',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                              const Icon(Icons.star,
                                  color: Colors.white, size: 12),
                              Positioned(
                                  bottom: 20,
                                  child: Text(
                                    NumberFormat.currency(locale: 'bs')
                                        .format(p.price),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ))
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ));
      },
    );

    return Column(
      children: groups,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return child!;
      },
    );
    if (picked != null && !picked.isSameDate(selectedDate)) {
      _dateProvider.addDate(picked);
    }
  }

  void selectProjection(Shows s) {
    setState(() {
      if (selectedShow == s) {
        selectedShow = null;
      } else {
        selectedShow = s;
      }
    });
  }
}

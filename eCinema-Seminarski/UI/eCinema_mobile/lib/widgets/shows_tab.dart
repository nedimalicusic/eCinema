// ignore_for_file: empty_catches

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
  List<Shows> shows = [];
  List<Cinema> cinemas = [];

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

  Future<void> loadData() async {
    await loadCinemas();
    await loadShows();
  }

  Future<void> loadShows() async {
    if (selectedCinema == null) return;
    setState(() => loading = true);

    final search = ShowSearchObject(
      movieId: widget.movieId,
      cinemaId: selectedCinema!.id,
      date: selectedDate,
    );

    try {
      final data = await _showProvider.getPaged(searchObject: search);
      if (!mounted) return;
      setState(() {
        shows = data;
        loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> loadCinemas() async {
    try {
      final data = await _cinemaProvider.get(null);
      if (!mounted) return;
      setState(() {
        cinemas = data;
        selectedCinema = data.isNotEmpty ? data.first : null;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final date = context.watch<DateProvider>().selectedDate;
    if (selectedDate != date) {
      selectedDate = date;
      selectedShow = null;
      loadShows();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildDateHeader(context),
          const DateSelector(),
          _buildCinemasDropdown(),
          _buildProjectionTickets(context),
          const SizedBox(height: 10),
          if (selectedShow != null) _buildReservationButton(context),
        ],
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Datum',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: () => _selectDate(context),
            borderRadius: BorderRadius.circular(30),
            child: const Icon(Icons.calendar_today, size: 26, color: Colors.teal),
          ),
        ],
      ),
    );
  }

  Widget _buildCinemasDropdown() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kino',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          if (cinemas.isEmpty)
            const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            )
          else
            DropdownButton<Cinema>(
              isExpanded: true,
              value: selectedCinema,
              icon: const Icon(Icons.arrow_drop_down),
              onChanged: (Cinema? value) {
                setState(() {
                  selectedCinema = value;
                  selectedShow = null;
                });
                loadShows();
              },
              items: cinemas
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(c.name),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildProjectionTickets(BuildContext context) {
    if (loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(color: Colors.teal),
        ),
      );
    }

    if (shows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'Nema dostupnih projekcija za odabrani datum.',
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
      );
    }

    final grouped = groupBy(shows, (Shows s) => s.showType.name);
    const ticketColor = Colors.teal;

    return Column(
      children: grouped.entries.map((entry) {
        final showType = entry.key;
        final list = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                showType,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final show = list[index];
                  final isSelected = selectedShow == show;
                  return GestureDetector(
                    onTap: () => selectProjection(show),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/ticket120.png',
                            color: isSelected ? Colors.blue : ticketColor,
                            width: 120,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 20,
                            child: Text(
                              '${DateFormat('HH:mm').format(show.startsAt)}h',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            child: Text(
                              NumberFormat.currency(locale: 'bs', symbol: 'KM').format(show.price),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildReservationButton(BuildContext context) {
    return SizedBox(
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
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Rezervacija',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && !picked.isSameDate(selectedDate)) {
      _dateProvider.addDate(picked);
    }
  }

  void selectProjection(Shows s) {
    setState(() {
      selectedShow = selectedShow == s ? null : s;
    });
  }
}

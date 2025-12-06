// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:ecinema_mobile/models/cinema.dart';
import 'package:ecinema_mobile/models/reservation.dart';
import 'package:ecinema_mobile/models/shows.dart';
import 'package:ecinema_mobile/providers/login_provider.dart';
import 'package:ecinema_mobile/providers/reservation_provider.dart';
import 'package:ecinema_mobile/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../helpers/constants.dart';
import '../models/seats.dart';
import '../providers/seats_provider.dart';
import '../utils/authorization.dart';

class SeatsScreen extends StatefulWidget {
  final Shows shows;
  const SeatsScreen({super.key, required this.shows});

  static const String routeName = '/seats';

  @override
  State<SeatsScreen> createState() => _SeatsScreenState();
}

class _SeatsScreenState extends State<SeatsScreen> {
  var seats = <Seats>[];
  var takenSeatIds = <int>[];
  var selectedSeats = <Seats>[];
  var reservations = <Reservation>[];
  late Cinema cinema;

  late SeatsProvider seatProvider;
  late UserLoginProvider userProvider;
  late ReservationProvider reservationProvider;

  @override
  void initState() {
    super.initState();
    seatProvider = context.read<SeatsProvider>();
    userProvider = context.read<UserLoginProvider>();
    reservationProvider = context.read<ReservationProvider>();

    takenSeats();
  }

  void takenSeats() async {
    reservations = await reservationProvider.getByShowId(widget.shows.id);
    setState(() {
      takenSeatIds = reservations.map((r) => r.seatId).toList();
    });
    load();
  }

  updateTicketProvider() {
    reservationProvider.setSelectedSeats(selectedSeats);
    reservationProvider.setProjection(widget.shows);
  }

  void load() async {
    var data = await seatProvider.getPaged();
    var seatsData = data.map<Seats>(
      (s) {
        var seat = Seats(id: s.id, column: s.column, row: s.row);
        if (takenSeatIds.any((id) => id == s.id)) {
          seat.isReserved = true;
        }
        return seat;
      },
    ).toList();
    if (mounted) {
      setState(() {
        seats = seatsData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Select Seats',
            textAlign: TextAlign.center,
          ),
        ),
        body: Column(
          children: [
            _buildShowHeader(),
            const Divider(
              height: 2,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 40,
            ),
            _buildCinemaScreen(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      constraints: const BoxConstraints(minHeight: 30),
                      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      child: seats.isNotEmpty
                          ? GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 10,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 10,
                              children: _buildSeats(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Colors.teal,
                              ),
                            ),
                    ),
                    const Divider(
                      height: 2,
                      color: Colors.grey,
                    ),
                    _buildInfoBoxes(),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  List<Widget> _buildSeats() {
    return seats.map((s) {
      return InkWell(
        onTap: () {
          if (s.isReserved) {
            return;
          }
          if (!selectedSeats.contains(s)) {
            selectedSeats.add(s);
          } else {
            selectedSeats.remove(s);
          }
          setState(() {
            s.isSelected = !s.isSelected;
          });
        },
        child: Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: s.isReserved
                ? Colors.red
                : s.isSelected
                    ? Colors.green
                    : null,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildShowHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 20, left: 10),
            width: 90,
            height: 120,
            child: widget.shows.movie.photo?.guidId != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: NetworkImage(
                        '$apiUrl/Photo/GetById?id=${widget.shows.movie.photo?.guidId}&original=true',
                        headers: Authorization.createHeaders(),
                      ),
                      fadeInDuration: const Duration(milliseconds: 300),
                      fit: BoxFit.fill,
                    ),
                  )
                : const Placeholder(),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.shows.movie.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${DateFormat.Hm().format(widget.shows.startsAt)} - ${DateFormat.Hm().format(widget.shows.endsAt)}  |  ${DateFormat.MMMMEEEEd('bs').format(widget.shows.startsAt)}',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: Column(
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'Slobodno',
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'Zauzeto',
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    border: Border.all(color: Colors.teal),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'Odabrano',
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCinemaScreen() {
    return Container(
      height: 12,
      width: 350,
      decoration: const BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.vertical(
          top: Radius.elliptical(400, 100),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 100,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (selectedSeats.isNotEmpty)
                  Text(
                    'Sjedište: ${selectedSeats.join(', ')}'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (selectedSeats.isNotEmpty) const SizedBox(height: 8),
                Text(
                  "${widget.shows.price * (selectedSeats.isNotEmpty ? selectedSeats.length : 1)}KM",
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedSeats.isNotEmpty) {
                    updateTicketProvider();
                    Navigator.pushNamed(context, PaymentScreen.routeName);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Upozorenje"),
                          content: const Text("Molimo odaberite minimalno jedno sjedalo prije plaćanja."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
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
                  'Buy ticket',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

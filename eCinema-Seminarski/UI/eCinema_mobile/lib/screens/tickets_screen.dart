import 'package:ecinema_mobile/models/reservation.dart';
import 'package:ecinema_mobile/providers/reservation_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../providers/photo_provider.dart';
import '../utils/authorization.dart';
import '../utils/error_dialog.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({Key? key}) : super(key: key);

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  late ReservationProvider _reservationProvider;
  late PhotoProvider _photoProvider;
  List<Reservation> reservations = <Reservation>[];

  @override
  void initState() {
    super.initState();
    _reservationProvider = context.read<ReservationProvider>();
    _photoProvider = context.read<PhotoProvider>();
    loadReservations();
  }

  Future loadReservations() async {
    try {
      var data = await _reservationProvider.getByUserId(1);
      setState(() {
        reservations = data;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  Future<String> loadPhoto(String guidId) async {
    return await _photoProvider.getPhoto(guidId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tickets"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: _buildReservationList(reservations),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationList(List<Reservation> reservations) {
    return ListView.builder(
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        return _buildReservation(context, reservations[index]);
      },
    );
  }

  Widget _buildReservation(BuildContext context, Reservation reservation) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.teal, width: 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: FutureBuilder<String>(
              future: loadPhoto(reservation.show.movie.photo.guidId ?? ''),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    value: 16,
                  ));
                } else if (snapshot.hasError) {
                  return const Text('Greška prilikom učitavanja slike');
                } else {
                  final imageUrl = snapshot.data;

                  if (imageUrl != null && imageUrl.isNotEmpty) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage(
                        image: NetworkImage(
                          imageUrl,
                          headers: Authorization.createHeaders(),
                        ),
                        placeholder: MemoryImage(kTransparentImage),
                        fadeInDuration: const Duration(milliseconds: 300),
                        fit: BoxFit.fill,
                        width: 70,
                        height: 115,
                      ),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Image.asset(
                        'assets/images/user2.png',
                        width: 70,
                        height: 115,
                        fit: BoxFit.fill,
                      ),
                    );
                  }
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: const [
                    Icon(Icons.play_arrow_rounded, color: Colors.teal),
                    SizedBox(height: 10),
                    Icon(Icons.calendar_month, color: Colors.teal),
                    SizedBox(height: 10),
                    Icon(Icons.timer_outlined, color: Colors.teal),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    Text(
                      reservation.show.movie.title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      DateFormat('dd.MM.yyyy')
                          .format(reservation.show.startsAt),
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      DateFormat.Hm().format(reservation.show.endsAt),
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                height: 115,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    reservation.seat.row + reservation.seat.column.toString(),
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

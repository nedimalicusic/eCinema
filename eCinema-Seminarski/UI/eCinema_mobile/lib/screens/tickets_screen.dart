import 'package:ecinema_mobile/models/reservation.dart';
import 'package:ecinema_mobile/providers/movie_provider.dart';
import 'package:ecinema_mobile/providers/reservation_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../helpers/constants.dart';
import '../providers/login_provider.dart';
import '../utils/authorization.dart';
import '../utils/error_dialog.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({Key? key}) : super(key: key);

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  late ReservationProvider _reservationProvider;
  late UserLoginProvider userProvider;
  late MovieProvider _reactionProvider;

  List<Reservation> reservations = <Reservation>[];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _reservationProvider = context.read<ReservationProvider>();
    userProvider = context.read<UserLoginProvider>();
    _reactionProvider = context.read<MovieProvider>();
    loadReservations();
  }

  Future loadReservations() async {
    try {
      var data = await _reservationProvider.getByUserId(int.parse(userProvider.user!.id));

      if (!mounted) return;

      setState(() {
        reservations = data;
        isLoading = false;
      });
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rezervacije"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            )
          : reservations.isEmpty
              ? const Center(
                  child: Text(
                    'Nema rezervacija.',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : _buildReservationList(reservations),
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
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.teal.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 75,
                  height: 100,
                  child: reservation.show.movie.photo?.guidId != null
                      ? FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: NetworkImage(
                            '$apiUrl/Photo/GetById?id=${reservation.show.movie.photo?.guidId}&original=true',
                            headers: Authorization.createHeaders(),
                          ),
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.movie, size: 40, color: Colors.grey),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.play_arrow_rounded, color: Colors.teal, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            reservation.show.movie.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, color: Colors.teal, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd.MM.yyyy').format(reservation.show.startsAt),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, color: Colors.teal, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat.Hm().format(reservation.show.endsAt),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "${reservation.seat.row}${reservation.seat.column}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ocijeni film:",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: List.generate(5, (index) {
                  final isRated = reservation.show.movie.userRating != null && index < reservation.show.movie.userRating!;
                  return Expanded(
                    child: IconButton(
                      icon: Icon(
                        isRated ? Icons.star_rounded : Icons.star_border_rounded,
                        color: Colors.amber.shade600,
                        size: 30,
                      ),
                      onPressed: () async {
                        try {
                          await _reactionProvider.insertMovieReaction(
                            int.parse(userProvider.user!.id),
                            reservation.show.movie.id,
                            index + 1,
                          );

                          if (!mounted) return;
                          setState(() {
                            reservation.show.movie.userRating = index + 1;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.teal,
                              content: Text(
                                'Ocjena ${index + 1} sačuvana!',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        } catch (e) {
                          if (!mounted) return;
                          showErrorDialog(context, e.toString());
                        }
                      },
                    ),
                  );
                }),
              )
            ],
          ),
        ],
      ),
    );
  }
}

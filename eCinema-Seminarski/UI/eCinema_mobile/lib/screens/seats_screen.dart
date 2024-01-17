import 'package:ecinema_mobile/models/shows.dart';
import 'package:ecinema_mobile/providers/cinema_provider.dart';
import 'package:ecinema_mobile/providers/reservation_provider.dart';
import 'package:ecinema_mobile/providers/show_provider.dart';
import 'package:ecinema_mobile/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/constants.dart';
import '../models/movie.dart';
import '../models/seats.dart';
import '../providers/seats_provider.dart';
import '../providers/user_provider.dart';
import '../utils/error_dialog.dart';
import 'package:intl/intl.dart';


class SeatsScreen extends StatefulWidget {
  const SeatsScreen({super.key, required this.shows});

  static const String routeName = '/seats';
  final Shows shows;

  @override
  State<SeatsScreen> createState() => _SeatsScreenState();
}

class _SeatsScreenState extends State<SeatsScreen> {
  var seats = <Seats>[];
  var takenSeatIds = <int>[];
  var selectedSeats = <Seats>[];
  var shows = <Shows>[];
  var cinema;

  late SeatsProvider seatProvider;
  late UserProvider userProvider;
  late CinemaProvider cinemaProvider;
  late ShowProvider showProvider;
  late ReservationProvider reservationProvider;

  @override
  void initState() {
    super.initState();
    seatProvider = context.read<SeatsProvider>();
    userProvider = context.read<UserProvider>();
    showProvider = context.read<ShowProvider>();
    cinemaProvider = context.read<CinemaProvider>();
    reservationProvider = context.read<ReservationProvider>();
    load();
    loadShows();
  }

  updateTicketProvider() {
    reservationProvider.setSelectedSeats(selectedSeats);
    reservationProvider.setProjection(widget.shows);

  }
  void loadShows() async {
    try {
      var showsData = await showProvider.getByMovieId(widget.shows.movie.id);
      setState(() {
        shows = showsData;
        print(shows);
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void load() async {
    cinema=cinemaProvider.getSelectCinema();
    var data = await seatProvider.getbyCinemaId(cinema.id);
    var seatsData = data.map<Seats>(
          (s) {
        var seat = Seats(id: s.id, column: s.column, row: s.row);
        if (takenSeatIds.any((id) => id == s.id)) {
          seat.isReserved = true;
        }
        return seat;
      },
    ).toList();
    setState(() {
      seats = seatsData;
    });
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
            const Divider(
              height: 2,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 30,
            ),
            _buildCinemaScreen(),
            Container(
              constraints: const BoxConstraints(minHeight: 100),
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: seats.isNotEmpty
                  ?  GridView.count(
                shrinkWrap: true,
                crossAxisCount: 10,
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
                children: _buildSeats(),
              )
                  : const Center(
                child: CircularProgressIndicator(
                  color: Colors.lightBlueAccent,
                ),
              ),
            ),
            const Divider(
              height: 2,
              color: Colors.grey,
            ),
            _buildInfoBoxes(),
            Center(
              child: Text("Select date and time",style: TextStyle(fontSize: 18,color: Colors.teal),),
            ),
            SizedBox(height: 10,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildDate(),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildTime(),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomBar(),
            )
          ],
        ),
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
  List<Widget> _buildDate() {
    return shows.map((s) {
      return Column(
        children: [
          Container(
            height: 50,
            width: 80,
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(
                  10.0), // Postavite željeni radijus zaobljenih ivica
            ),
            child: Center(
              child: Text(
                '${DateFormat('MMMM d').format(s.date)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
          ),

        ],
      );
    }).toList();
  }

  List<Widget> _buildTime() {
    return shows.map((s) {
    return Row(
      children: [
        Container(
          height: 35,
          width: 75,
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(10.0), // Postavite željeni radijus zaobljenih ivica
          ),
          child: Center(
            child: Text(
              '${DateFormat.Hm().format(s.startTime)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        )
      ],
    );
    }).toList();
  }

 Widget _buildInfoBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
        Container(
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
        Container(
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Sjedište: ${selectedSeats.join(', ')}'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  widget.shows.price.toString() + "KM",
                  style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 150,
            height: 50,
            child: ElevatedButton(
                onPressed: () {
                  updateTicketProvider();
                  Navigator.pushNamed(context, PaymentScreen.routeName);
                },
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(Colors.teal),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              child: const Text(
                'Buy ticket',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

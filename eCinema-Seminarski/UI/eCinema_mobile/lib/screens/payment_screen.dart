import 'dart:convert';

import 'package:ecinema_mobile/providers/login_provider.dart';
import 'package:ecinema_mobile/providers/notification_provider.dart';
import 'package:ecinema_mobile/providers/reservation_provider.dart';
import 'package:ecinema_mobile/screens/profile_screen.dart';
import 'package:ecinema_mobile/screens/reservation_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../helpers/constants.dart';
import '../models/notifications.dart';
import '../providers/seats_provider.dart';
import '../utils/authorization.dart';
import '../utils/error_dialog.dart';

class PaymentScreen extends StatefulWidget {
  static const String routeName = '/payment';

  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late SeatsProvider seatsProvider;
  late UserLoginProvider userProvider;
  late ReservationProvider reservationProvider;
  late NotificationProvider notificationProvider;

  @override
  void initState() {
    super.initState();
    seatsProvider = context.read<SeatsProvider>();
    userProvider = context.read<UserLoginProvider>();
    reservationProvider = context.read<ReservationProvider>();
    notificationProvider = context.read<NotificationProvider>();
  }

  showPaymentSheet() async {
    try {
      var paymentIntentData = await createPaymentIntent(
          (reservationProvider.selectedTicketTotalPrice * 100)
              .round()
              .toString(),
          'BAM');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          merchantDisplayName: 'eCinema',
          appearance: const PaymentSheetAppearance(
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                  light: PaymentSheetPrimaryButtonThemeColors(
                      background: Colors.teal)),
            ),
          ),
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      await reservate();
    } on StripeException {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Poništena transakcija"),
        ),
      );
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          });
      return jsonDecode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future reservate() async {
    if (userProvider.user == null) {
      Navigator.pushNamed(context, ProfileScreen.routeName);
      return;
    }
    try {
      final reservations = <Map>[];
      for (var seat in reservationProvider.selectedSeats) {
        reservations.add({
          'userId': userProvider.user!.id,
          'showId': reservationProvider.shows!.id,
          'seatId': seat.id
        });
      }
      var response = await reservationProvider.insert(reservations);
      if (response == "OK") {
        await notificationProvider.create(Notifications(
          title: 'Rezervacija',
          description: 'Vaša rezervacija je uspješno kreirana.',
          userId: int.parse(userProvider.user!.id),
          sendOnDate: DateTime.now(),
          seen: false,
        ));
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, ReservationSuccessScreen.routeName, (route) => false);
        }
      } else {
        throw Exception("Greska prilikom kreiranja rezervacije");
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kupovina'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 12),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 170,
                          child: reservationProvider
                                      .shows?.movie.photo?.guidId !=
                                  null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: FadeInImage(
                                    placeholder: MemoryImage(kTransparentImage),
                                    image: NetworkImage(
                                      '$apiUrl/Photo/GetById?id=${reservationProvider.shows!.movie.photo?.guidId}&original=true',
                                      headers: Authorization.createHeaders(),
                                    ),
                                    fadeInDuration:
                                        const Duration(milliseconds: 300),
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : Image.asset(
                                  'assets/images/nophoto.jpg',
                                  fit: BoxFit.fill,
                                ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reservationProvider.shows!.movie.title,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  reservationProvider.shows!.cinema.name,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  reservationProvider.shows!.showType.name,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  '${DateFormat.Hm().format(reservationProvider.shows!.startsAt)} - ${DateFormat.Hm().format(reservationProvider.shows!.endsAt)}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  DateFormat.MMMMEEEEd('bs').format(
                                      reservationProvider.shows!.startsAt),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  'Sjedište ${reservationProvider.selectedSeats.join(', ').toString()}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ukupno',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    NumberFormat.currency(locale: 'bs')
                        .format(reservationProvider.selectedTicketTotalPrice),
                    style: const TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  onPressed: () async => await showPaymentSheet(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text(
                    'Plaćanje',
                    style: TextStyle(fontSize: 18),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

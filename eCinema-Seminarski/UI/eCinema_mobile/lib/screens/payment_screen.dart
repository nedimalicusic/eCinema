import 'dart:convert';

import 'package:ecinema_mobile/providers/login_provider.dart';
import 'package:ecinema_mobile/providers/reservation_provider.dart';
import 'package:ecinema_mobile/providers/user_provider.dart';
import 'package:ecinema_mobile/screens/profile_screen.dart';
import 'package:ecinema_mobile/screens/reservation_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../helpers/constants.dart';
import '../providers/seats_provider.dart';
import '../utils/authorization.dart';
import '../utils/error_dialog.dart';

class PaymentScreen extends StatefulWidget {
  static const String routeName = 'payment';

  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late SeatsProvider seatsProvider;
  late UserLoginProvider userProvider;
  late ReservationProvider reservationProvider;

  @override
  void initState() {
    super.initState();
    seatsProvider = context.read<SeatsProvider>();
    userProvider = context.read<UserLoginProvider>();
    reservationProvider = context.read<ReservationProvider>();
  }

  showPaymentSheet() async {
    var paymentIntentData = await createPaymentIntent(
        (reservationProvider.selectedTicketTotalPrice * 100).round().toString(),
        'BAM');
    await Stripe.instance
        .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntentData!['client_secret'],
                merchantDisplayName: 'eCinema'))
        .then((value) {})
        .onError((error, stackTrace) {
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Poništena transakcija"),
              ));
    });

    try {
      await Stripe.instance.presentPaymentSheet();
      await reservate();
    } catch (e) {}
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
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
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
          'userId': userProvider.user!.Id,
          'projectionId': reservationProvider.shows!.id,
          'seatId': seat.id
        });
      }
      await reservationProvider.insert(reservations);

      userProvider.refreshUser();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, ReservationSuccessScreen.routeName, (route) => false);
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
          title: const Text('Plaćanje'),
        ),
      ),
    );
  }
}

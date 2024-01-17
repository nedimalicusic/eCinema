import 'package:ecinema_admin/models/loginUser.dart';
import 'package:ecinema_admin/providers/actor_provider.dart';
import 'package:ecinema_admin/providers/cinema_provider.dart';
import 'package:ecinema_admin/providers/city_provider.dart';
import 'package:ecinema_admin/providers/country_provider.dart';
import 'package:ecinema_admin/providers/employee_provider.dart';
import 'package:ecinema_admin/providers/genre_provider.dart';
import 'package:ecinema_admin/providers/language_provider.dart';
import 'package:ecinema_admin/providers/login_provider.dart';
import 'package:ecinema_admin/providers/movie_provider.dart';
import 'package:ecinema_admin/providers/photo_provider.dart';
import 'package:ecinema_admin/providers/production_provider.dart';
import 'package:ecinema_admin/providers/reservation_provider.dart';
import 'package:ecinema_admin/providers/seats_provider.dart';
import 'package:ecinema_admin/providers/show_provider.dart';
import 'package:ecinema_admin/providers/user_provider.dart';
import 'package:ecinema_admin/screens/home_screen.dart';
import 'package:ecinema_admin/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => CinemaProvider()),
          ChangeNotifierProvider(create: (_) => ProductionProvider()),
          ChangeNotifierProvider(create: (_) => ReservationProvider()),
          ChangeNotifierProvider(create: (_) => MovieProvider()),
          ChangeNotifierProvider(create: (_) => ActorProvider()),
          ChangeNotifierProvider(create: (_) => EmployeeProvider()),
          ChangeNotifierProvider(create: (_) => GenreProvider()),
          ChangeNotifierProvider(create: (_) => CountryProvider()),
          ChangeNotifierProvider(create: (_) => CityProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => ShowProvider()),
          ChangeNotifierProvider(create: (_) => SeatsProvider()),
          ChangeNotifierProvider(create: (_) => LoginProvider()),
          ChangeNotifierProvider(create: (_) => PhotoProvider()),
        ],
        child: MaterialApp(
          title: 'eCinema application',
          routes: {
            LoginScreen.routeName: (context) => const LoginScreen(),
            HomeScreen.routeName: (context) => const HomeScreen(),
          },
          theme: ThemeData(
            primarySwatch: Colors.teal,
          ),
          home: const MyHomePage(title: 'eCinema application'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late LoginProvider loginUserprovider;

  @override
  void initState() {
    super.initState();
    loginUserprovider = context.read<LoginProvider>();
  }

  @override
  Widget build(BuildContext context) {
    LoginUser? loginUser = loginUserprovider.loginUser;
    if (loginUser == null) {
      return const LoginScreen();
    }
    return const LoginScreen();
  }
}

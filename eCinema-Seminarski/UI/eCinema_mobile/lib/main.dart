import 'dart:io';
import 'package:ecinema_mobile/models/shows.dart';
import 'package:ecinema_mobile/models/user.dart';
import 'package:ecinema_mobile/providers/cinema_provider.dart';
import 'package:ecinema_mobile/providers/genre_provider.dart';
import 'package:ecinema_mobile/providers/movie_provider.dart';
import 'package:ecinema_mobile/providers/notification_provider.dart';
import 'package:ecinema_mobile/providers/reservation_provider.dart';
import 'package:ecinema_mobile/providers/seats_provider.dart';
import 'package:ecinema_mobile/providers/show_provider.dart';
import 'package:ecinema_mobile/providers/user_provider.dart';
import 'package:ecinema_mobile/screens/cinema_screen.dart';
import 'package:ecinema_mobile/screens/home_screen.dart';
import 'package:ecinema_mobile/screens/login_screen.dart';
import 'package:ecinema_mobile/screens/movie_detail_screen.dart';
import 'package:ecinema_mobile/screens/movies_screen.dart';
import 'package:ecinema_mobile/screens/notification_screen.dart';
import 'package:ecinema_mobile/screens/payment_screen.dart';
import 'package:ecinema_mobile/screens/profile_screen.dart';
import 'package:ecinema_mobile/screens/register_screen.dart';
import 'package:ecinema_mobile/screens/seats_screen.dart';
import 'package:ecinema_mobile/screens/tickets_screen.dart';
import 'package:ecinema_mobile/screens/change_password.dart';
import 'package:ecinema_mobile/screens/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/movie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider(create: (_) => GenreProvider()),
        ChangeNotifierProvider(create: (_) => SeatsProvider()),
        ChangeNotifierProvider(create: (_) => GenreProvider()),
        ChangeNotifierProvider(create: (_) => ShowProvider()),
        ChangeNotifierProvider(create: (_) => CinemaProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
      ],
      child: MaterialApp(
          theme: ThemeData(primarySwatch: Colors.teal),
          routes: {
            LoginScreen.routeName: (context) => const LoginScreen(),
            RegisterScreen.routeName: (context) => const RegisterScreen(),
            CinemaScreen.routeName: (context) => const CinemaScreen(),
            PaymentScreen.routeName: (context) => const PaymentScreen(),
            ChangePasswordScreen.routeName: (context) =>
                const ChangePasswordScreen(),
            EditProfileScreen.routeName: (context) => const EditProfileScreen()
          },
          onGenerateRoute: (settings) {
            if (settings.name == SeatsScreen.routeName) {
              return MaterialPageRoute(
                  builder: (context) => SeatsScreen(
                      shows: settings.arguments as Shows));
            }
            if (settings.name == MovieDetailScreen.routeName) {
              return MaterialPageRoute(
                  builder: (context) =>
                      MovieDetailScreen(shows: settings.arguments as Shows));
            }
            if (settings.name == '/') {
              return MaterialPageRoute(
                  builder: (context) => Main(
                      index: settings.arguments != null
                          ? settings.arguments as int
                          : 0));
            }
            return null;
          }),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key, this.index = 0});

  final int index;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final List<Widget> screens = [
    const HomeScreen(),
    const MoviesScreen(),
    const TicketsScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  late int _selectedIndex;
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;

    userProvider = context.read<UserProvider>();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = userProvider.user;
    if (user == null) {
      return const LoginScreen();
    }
    return SafeArea(
      child: Scaffold(
        body: screens.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.home_filled,
              ),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.theaters,
              ),
              label: 'Movie',
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.local_activity,
              ),
              label: 'Ticket',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notification',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:ecinema_mobile/models/movie.dart';
import 'package:ecinema_mobile/models/shows.dart';
import 'package:ecinema_mobile/models/login_user.dart';
import 'package:ecinema_mobile/providers/category_provider.dart';
import 'package:ecinema_mobile/providers/cinema_provider.dart';
import 'package:ecinema_mobile/providers/date_provider.dart';
import 'package:ecinema_mobile/providers/genre_provider.dart';
import 'package:ecinema_mobile/providers/login_provider.dart';
import 'package:ecinema_mobile/providers/movie_provider.dart';
import 'package:ecinema_mobile/providers/notification_provider.dart';
import 'package:ecinema_mobile/providers/photo_provider.dart';
import 'package:ecinema_mobile/providers/reservation_provider.dart';
import 'package:ecinema_mobile/providers/seats_provider.dart';
import 'package:ecinema_mobile/providers/show_provider.dart';
import 'package:ecinema_mobile/providers/user_provider.dart';
import 'package:ecinema_mobile/screens/home_screen.dart';
import 'package:ecinema_mobile/screens/login_screen.dart';
import 'package:ecinema_mobile/screens/movie_detail_screen.dart';
import 'package:ecinema_mobile/screens/movies_screen.dart';
import 'package:ecinema_mobile/screens/notification_screen.dart';
import 'package:ecinema_mobile/screens/payment_screen.dart';
import 'package:ecinema_mobile/screens/profile_screen.dart';
import 'package:ecinema_mobile/screens/register_screen.dart';
import 'package:ecinema_mobile/screens/reservation_success.dart';
import 'package:ecinema_mobile/screens/seats_screen.dart';
import 'package:ecinema_mobile/screens/tickets_screen.dart';
import 'package:ecinema_mobile/screens/change_password.dart';
import 'package:ecinema_mobile/screens/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'helpers/constants.dart';
import 'helpers/my_http_overrides.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  Stripe.publishableKey = stripePublishKey;

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await initializeDateFormatting('bs');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider(create: (_) => GenreProvider()),
        ChangeNotifierProvider(create: (_) => SeatsProvider()),
        ChangeNotifierProvider(create: (_) => ShowProvider()),
        ChangeNotifierProvider(create: (_) => CinemaProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
        ChangeNotifierProvider(create: (_) => PhotoProvider()),
        ChangeNotifierProvider(create: (_) => UserLoginProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => DateProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.teal),
        routes: {
          LoginScreen.routeName: (context) => const LoginScreen(),
          RegisterScreen.routeName: (context) => const RegisterScreen(),
          PaymentScreen.routeName: (context) => const PaymentScreen(),
          ChangePasswordScreen.routeName: (context) => const ChangePasswordScreen(),
          EditProfileScreen.routeName: (context) => const EditProfileScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == SeatsScreen.routeName) {
            return MaterialPageRoute(builder: (context) => SeatsScreen(shows: settings.arguments as Shows));
          }
          if (settings.name == ReservationSuccessScreen.routeName) {
            return MaterialPageRoute(builder: (context) => const ReservationSuccessScreen());
          }
          if (settings.name == MovieDetailScreen.routeName) {
            return MaterialPageRoute(builder: (context) => MovieDetailScreen(movie: settings.arguments as Movie));
          }
          if (settings.name == '/') {
            return MaterialPageRoute(builder: (context) => Main(index: settings.arguments != null ? settings.arguments as int : 0));
          }
          return null;
        },
      ),
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
  late UserLoginProvider userProvider;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
    userProvider = context.read<UserLoginProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationProvider = context.read<NotificationProvider>();
      if (userProvider.user != null) {
        notificationProvider.loadByUserId(int.parse(userProvider.user!.id));
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserLogin? user = userProvider.user;
    if (user == null) {
      return const LoginScreen();
    }

    return SafeArea(
      child: Scaffold(
        body: screens.elementAt(_selectedIndex),
        bottomNavigationBar: Consumer<NotificationProvider>(
          builder: (context, notifier, child) {
            return BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.theaters),
                  label: 'Movie',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.local_activity),
                  label: 'Ticket',
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    children: [
                      const Icon(Icons.notifications),
                      if (notifier.unreadCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Text(
                              notifier.unreadCount.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
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
            );
          },
        ),
      ),
    );
  }
}

import 'package:ecinema_admin/models/loginUser.dart';
import 'package:ecinema_admin/screens/cities_screens/city_screen.dart';
import 'package:ecinema_admin/screens/countries_screens/counry_screen.dart';
import 'package:ecinema_admin/screens/languages_screens/langauge_screen.dart';
import 'package:ecinema_admin/screens/productions_screens/productions_screen.dart';
import 'package:ecinema_admin/screens/reports_screens/reports_screen.dart';
import 'package:ecinema_admin/screens/reservations_screens/reservations_screen.dart';
import 'package:ecinema_admin/screens/shows_screens/shows_screen.dart';
import 'package:ecinema_admin/screens/users_screens/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/login_provider.dart';
import 'cinema_screens/cinemas_screen.dart';
import 'dashboard_screen.dart';
import 'employees_screens/employees_screen.dart';
import 'genres_screens/genres_screen.dart';
import 'login_screen.dart';
import 'movies_screens/movies_screen.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
    required this.onMenuItemClicked,
  }) : super(key: key);

  final Function(Widget) onMenuItemClicked;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late LoginProvider loginUserProvider;
  late LoginUser? loginUser;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    loginUserProvider = context.read<LoginProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.teal,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.slow_motion_video_rounded,
                          color: Colors.white, size: 24),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "eCinema",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                ),
                DrawerListTile(
                  title: "Dashboard",
                  svgSrc: "assets/icons/dash.svg",
                  press: () {
                    widget.onMenuItemClicked(const DashboardScreen());
                  },
                ),
                DrawerListTile(
                  title: "Korisnici",
                  svgSrc: "assets/icons/users.svg",
                  press: () {
                    widget.onMenuItemClicked(const UsersScreen());
                  },
                ),
                DrawerListTile(
                  title: "Uposlenici",
                  svgSrc: "assets/icons/activeUser.svg",
                  press: () {
                    widget.onMenuItemClicked(const EmployeesScreen());
                  },
                ),
                DrawerListTile(
                  title: "Kina",
                  svgSrc: "assets/icons/movie.svg",
                  press: () {
                    widget.onMenuItemClicked(const CinemasScreen());
                  },
                ),
                DrawerListTile(
                  title: "Projekcije",
                  svgSrc: "assets/icons/cinema.svg",
                  press: () {
                    widget.onMenuItemClicked(const ShowsScreen());
                  },
                ),
                DrawerListTile(
                  title: "Filmovi",
                  svgSrc: "assets/icons/show.svg",
                  press: () {
                    widget.onMenuItemClicked(const MoviesScreen());
                  },
                ),
                DrawerListTile(
                  title: "Produkcije",
                  svgSrc: "assets/icons/production.svg",
                  press: () {
                    widget.onMenuItemClicked(const ProductionScreen());
                  },
                ),
                DrawerListTile(
                  title: "Žanrovi",
                  svgSrc: "assets/icons/genre.svg",
                  press: () {
                    widget.onMenuItemClicked(const GenresScreen());
                  },
                ),
                DrawerListTile(
                  title: "Rezervacije",
                  svgSrc: "assets/icons/reservation.svg",
                  press: () {
                    widget.onMenuItemClicked(const ReservationsScreen());
                  },
                ),
                DrawerListTile(
                  title: "Izvještaji",
                  svgSrc: "assets/icons/report.svg",
                  press: () {
                    widget.onMenuItemClicked(const ReportScreen());
                  },
                ),
                ExpansionTile(
                  onExpansionChanged: (value) {
                    setState(() {
                      isExpanded = value;
                    });
                  },
                  title: const Text(
                    "Referentni podaci",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Icon(
                    !isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: Colors.white,
                  ),
                  children: <Widget>[
                    DrawerListTile(
                      title: "Države",
                      svgSrc: "assets/icons/country.svg",
                      press: () {
                        widget.onMenuItemClicked(const CountryScreen());
                      },
                    ),
                    DrawerListTile(
                      title: "Gradovi",
                      svgSrc: "assets/icons/city.svg",
                      press: () {
                        widget.onMenuItemClicked(const CityScreen());
                      },
                    ),
                    DrawerListTile(
                      title: "Jezici",
                      svgSrc: "assets/icons/language.svg",
                      press: () {
                        widget.onMenuItemClicked(const LanguageScreen());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          DrawerListTile(
            title: "Logout",
            svgSrc: "assets/icons/logout.svg",
            press: () {
              loginUserProvider.logout();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white,
        height: 21,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

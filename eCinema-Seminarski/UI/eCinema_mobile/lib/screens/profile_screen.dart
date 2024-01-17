import 'package:ecinema_mobile/helpers/constants.dart';
import 'package:ecinema_mobile/models/user.dart';
import 'package:ecinema_mobile/providers/user_provider.dart';
import 'package:ecinema_mobile/screens/login_screen.dart';
import 'package:ecinema_mobile/utils/authorization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecinema_mobile/screens/change_password.dart';
import 'package:ecinema_mobile/screens/edit_profile.dart';

import '../utils/error_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProvider userProvider;
  late User? user;


  @override
  void initState() {
    super.initState();
    userProvider = context.read<UserProvider>();
    //loadUser();
  }

  void loadUser() async
  {
    try {
      var data = await userProvider.getById(int.parse(user!.Id));
      setState(() {
        user = data;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  @override
  Widget build(BuildContext context) {
    user = context.watch<UserProvider>().user;
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      });
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Center(child: ProfilePicture()),
          SizedBox(
            height: 10,
          ),
          ProfileInformation(),
          SizedBox(
            height: 5,
          ),
          Center(child: Logout()),
        ],
      ),
    );
  }

  Widget Logout() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 400,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: userProvider.logout,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Logout')
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ProfilePicture() {
    return Column(
      children: [
        Image.asset(
          'assets/images/user.png',
          width: 100,
          height: 100,
        ),
        SizedBox(
          width: 150,
          child: ElevatedButton(
            onPressed: () {},
            child: Text("Change picture"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget ProfileInformation() {
    return Container(
      child: Container(
        width: 400,
        margin: EdgeInsets.all(24),
        child: Column(children: [
          TextFormField(
            initialValue: user!.FirstName,
            decoration: InputDecoration(
              labelText: "FirstName",
              border: OutlineInputBorder( // Postavite border na OutlineInputBorder.
                borderRadius: BorderRadius.circular(10.0), // Prilagodite radijus ruba po želji.
              ),
              enabledBorder: OutlineInputBorder( // Prilagodite izgled obruba kad je polje omogućeno.
                borderSide: BorderSide(color: Colors.blue, width: 2.0), // Prilagodite boju i debljinu obruba.
                borderRadius: BorderRadius.circular(10.0),
              ),
              disabledBorder: OutlineInputBorder( // Prilagodite izgled obruba kad je polje onemogućeno.
                borderSide: BorderSide(color: Colors.grey, width: 2.0), // Prilagodite boju i debljinu obruba.
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder( // Prilagodite izgled obruba kad je polje fokusirano.
                borderSide: BorderSide(color: Colors.blue, width: 2.0), // Prilagodite boju i debljinu obruba.
                borderRadius: BorderRadius.circular(10.0),
              ),
              // Možete dodati i druge opcije poput fillColor, errorBorder, itd.
            ),
            enabled: false,
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: user!.LastName,
            decoration: InputDecoration(
              labelText: "LastName",
              border: OutlineInputBorder( // Postavite border na OutlineInputBorder.
                borderRadius: BorderRadius.circular(10.0), // Prilagodite radijus ruba po želji.
              ),
              enabledBorder: OutlineInputBorder( // Prilagodite izgled obruba kad je polje omogućeno.
                borderSide: BorderSide(color: Colors.blue, width: 2.0), // Prilagodite boju i debljinu obruba.
                borderRadius: BorderRadius.circular(10.0),
              ),
              disabledBorder: OutlineInputBorder( // Prilagodite izgled obruba kad je polje onemogućeno.
                borderSide: BorderSide(color: Colors.grey, width: 2.0), // Prilagodite boju i debljinu obruba.
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder( // Prilagodite izgled obruba kad je polje fokusirano.
                borderSide: BorderSide(color: Colors.blue, width: 2.0), // Prilagodite boju i debljinu obruba.
                borderRadius: BorderRadius.circular(10.0),
              ),
              // Možete dodati i druge opcije poput fillColor, errorBorder, itd.
            ),
            enabled: false,
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: user!.Email,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder( // Postavite border na OutlineInputBorder.
                borderRadius: BorderRadius.circular(10.0), // Prilagodite radijus ruba po želji.
              ),
              enabledBorder: OutlineInputBorder( // Prilagodite izgled obruba kad je polje omogućeno.
                borderSide: BorderSide(color: Colors.blue, width: 2.0), // Prilagodite boju i debljinu obruba.
                borderRadius: BorderRadius.circular(10.0),
              ),
              disabledBorder: OutlineInputBorder( // Prilagodite izgled obruba kad je polje onemogućeno.
                borderSide: BorderSide(color: Colors.grey, width: 2.0), // Prilagodite boju i debljinu obruba.
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder( // Prilagodite izgled obruba kad je polje fokusirano.
                borderSide: BorderSide(color: Colors.blue, width: 2.0), // Prilagodite boju i debljinu obruba.
                borderRadius: BorderRadius.circular(10.0),
              ),
              // Možete dodati i druge opcije poput fillColor, errorBorder, itd.
            ),
            enabled: false,
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: user!.PhoneNumber,
            decoration: InputDecoration(
              labelText: "PhoneNumber",
              border: OutlineInputBorder( // Postavite border na OutlineInputBorder.
                borderRadius: BorderRadius.circular(10.0), // Prilagodite radijus ruba po želji.
              ),
              enabledBorder: OutlineInputBorder( // Prilagodite izgled obruba kad je polje omogućeno.
                borderSide: BorderSide(color: Colors.blue, width: 2.0), // Prilagodite boju i debljinu obruba.
                borderRadius: BorderRadius.circular(10.0),
              ),
              disabledBorder: OutlineInputBorder( // Prilagodite izgled obruba kad je polje onemogućeno.
                borderSide: BorderSide(color: Colors.grey, width: 2.0), // Prilagodite boju i debljinu obruba.
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder( // Prilagodite izgled obruba kad je polje fokusirano.
                borderSide: BorderSide(color: Colors.blue, width: 2.0), // Prilagodite boju i debljinu obruba.
                borderRadius: BorderRadius.circular(10.0),
              ),
              // Možete dodati i druge opcije poput fillColor, errorBorder, itd.
            ),
            enabled: false,
          ),
          SizedBox(
            height: 10 ,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () {
                Navigator.pushNamed(context, EditProfileScreen.routeName);
              }, child: Text("Edit profile")),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(onPressed: () {
                Navigator.pushNamed(context, ChangePasswordScreen.routeName);
              }, child: Text("Change password")),
            ],
          ),
        ]),
      ),
    );
  }
}

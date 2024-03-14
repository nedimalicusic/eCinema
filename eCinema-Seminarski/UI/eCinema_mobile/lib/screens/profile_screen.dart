// ignore_for_file: non_constant_identifier_names

import 'package:ecinema_mobile/models/user.dart';
import 'package:ecinema_mobile/providers/user_provider.dart';
import 'package:ecinema_mobile/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecinema_mobile/screens/change_password.dart';
import 'package:ecinema_mobile/screens/edit_profile.dart';
import 'package:transparent_image/transparent_image.dart';

import '../providers/photo_provider.dart';
import '../utils/authorization.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProvider userProvider;
  late PhotoProvider _photoProvider;
  late User? user;

  @override
  void initState() {
    super.initState();
    userProvider = context.read<UserProvider>();
    _photoProvider = context.read<PhotoProvider>();
  }

  Future<String> loadPhoto(String guidId) async {
    return await _photoProvider.getPhoto(guidId);
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
          const SizedBox(height: 20),
          Center(child: ProfilePicture()),
          const SizedBox(height: 10),
          ProfileInformation(),
          const Spacer(),
          Center(child: Logout()),
        ],
      ),
    );
  }

  Widget Logout() {
    return Container(
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
    );
  }

  Widget ProfilePicture() {
    return Column(
      children: [
        FutureBuilder<String>(
          future: loadPhoto(user?.GuidId ?? ''),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Greška prilikom učitavanja slike');
            } else {
              final imageUrl = snapshot.data;

              if (imageUrl != null && imageUrl.isNotEmpty) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: FadeInImage(
                    image: NetworkImage(
                      imageUrl,
                      headers: Authorization.createHeaders(),
                    ),
                    placeholder: MemoryImage(kTransparentImage),
                    fadeInDuration: const Duration(milliseconds: 300),
                    fit: BoxFit.fill,
                    width: 110,
                    height: 110,
                  ),
                );
              } else {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.asset(
                    'assets/images/user2.png',
                    width: 110,
                    height: 110,
                    fit: BoxFit.fill,
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }

  Widget ProfileInformation() {
    return Container(
      width: 400,
      margin: const EdgeInsets.all(24),
      child: Column(children: [
        TextFormField(
          initialValue: user!.FirstName,
          decoration: InputDecoration(
            labelText: "FirstName",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          enabled: false,
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: user!.LastName,
          decoration: InputDecoration(
            labelText: "LastName",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          enabled: false,
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: user!.Email,
          decoration: InputDecoration(
            labelText: "Email",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          enabled: false,
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: user!.PhoneNumber,
          decoration: InputDecoration(
            labelText: "PhoneNumber",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          enabled: false,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(37),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, EditProfileScreen.routeName);
                  },
                  child: const Text("Edit profile")),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(37),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                        context, ChangePasswordScreen.routeName);
                  },
                  child: const Text("Change password")),
            ),
          ],
        ),
      ]),
    );
  }
}

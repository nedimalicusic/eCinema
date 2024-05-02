// ignore_for_file: non_constant_identifier_names

import 'package:ecinema_mobile/models/loginUser.dart';
import 'package:ecinema_mobile/providers/login_provider.dart';
import 'package:ecinema_mobile/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecinema_mobile/screens/change_password.dart';
import 'package:ecinema_mobile/screens/edit_profile.dart';
import 'package:transparent_image/transparent_image.dart';

import '../helpers/constants.dart';
import '../providers/photo_provider.dart';
import '../utils/authorization.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserLoginProvider userProvider;
  late PhotoProvider _photoProvider;
  late UserLogin? user;

  @override
  void initState() {
    super.initState();
    userProvider = context.read<UserLoginProvider>();
    _photoProvider = context.read<PhotoProvider>();
  }

  Future<String> loadPhoto(String guidId) async {
    return await _photoProvider.getPhoto(guidId);
  }

  @override
  Widget build(BuildContext context) {
    user = context.watch<UserLoginProvider>().user;
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
    return SizedBox(
      width: 110,
      height: 110,
      child: user!.GuidId != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(
                  '$apiUrl/Photo/GetById?id=${user!.GuidId}&original=true',
                  headers: Authorization.createHeaders(),
                ),
                fadeInDuration: const Duration(milliseconds: 300),
                fit: BoxFit.fill,
              ),
            )
          : const Placeholder(),
    );
  }

  Widget ProfileInformation() {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoItem("First Name", user!.FirstName),
          _buildInfoItem("Last Name", user!.LastName),
          _buildInfoItem("Email", user!.Email),
          _buildInfoItem("Phone Number", user!.PhoneNumber.toString()),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildButton("Edit profile", EditProfileScreen.routeName),
              const SizedBox(width: 5),
              _buildButton("Change password", ChangePasswordScreen.routeName),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, String routeName) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, routeName);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(8.0),
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:ecinema_mobile/models/login_user.dart';
import 'package:ecinema_mobile/providers/login_provider.dart';
import 'package:ecinema_mobile/screens/login_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ecinema_mobile/screens/change_password.dart';
import 'package:ecinema_mobile/screens/edit_profile.dart';
import 'package:transparent_image/transparent_image.dart';

import '../helpers/constants.dart';
import '../models/user.dart';
import '../providers/photo_provider.dart';
import '../providers/user_provider.dart';
import '../utils/authorization.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProvider _userProvider;
  late PhotoProvider _photoProvider;
  late UserLoginProvider _loginProvider;
  late UserLogin? loginUser;
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _loginProvider = context.read<UserLoginProvider>();
    _photoProvider = context.read<PhotoProvider>();
    _loadUser();
  }

  void _loadUser() async {
    isLoading = true;
    final id = _loginProvider.getUserId();
    loginUser = _loginProvider.user;

    final fetchedUser = await _userProvider.getById(id!);
    setState(() {
      user = fetchedUser;
      isLoading = false;
    });
  }

  Future<String> loadPhoto(String guidId) async {
    return await _photoProvider.getPhoto(guidId);
  }

  @override
  Widget build(BuildContext context) {
    loginUser = context.watch<UserLoginProvider>().user;

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (loginUser == null) {
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
              onPressed: _loginProvider.logout,
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
      child: user!.profilePhoto?.guidId != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(
                  '$apiUrl/Photo/GetById?id=${user!.profilePhoto!.guidId!}&original=true',
                  headers: Authorization.createHeaders(),
                ),
                fadeInDuration: const Duration(milliseconds: 300),
                fit: BoxFit.cover,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                'assets/images/user2.png',
                fit: BoxFit.cover,
              ),
            ),
    );
  }

  Widget ProfileInformation() {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoItem("First Name", user!.firstName),
          _buildInfoItem("Last Name", user!.lastName),
          _buildInfoItem("Email", user!.email),
          _buildInfoItem("Phone Number", user!.phoneNumber.toString()),
          _buildInfoItem(
            "Birth Date",
            user!.birthDate != null && user!.birthDate!.isNotEmpty ? DateFormat('d.M.yyyy.').format(DateTime.parse(user!.birthDate!).toLocal()) : '-',
          ),
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
            width: 120,
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
        onPressed: () async {
          final result = await Navigator.pushNamed(context, routeName);
          if (result == true) {
            _loadUser();
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(10.0),
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14.0),
        ),
      ),
    );
  }
}

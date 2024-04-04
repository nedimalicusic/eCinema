// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:ecinema_mobile/models/loginUser.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/user.dart';
import '../providers/login_provider.dart';
import '../providers/photo_provider.dart';
import '../providers/user_provider.dart';
import '../utils/authorization.dart';
import '../utils/error_dialog.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/editProfile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late UserProvider userProvider;
  late UserLoginProvider _loginProvider;
  late PhotoProvider _photoProvider;
  late User? user;
  late UserLogin? userLogin;
  final _formKey = GlobalKey<FormState>();
  ValueNotifier<File?> _pickedFileNotifier = ValueNotifier(null);
  File? _pickedFile;
  File? selectedImage;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    userProvider = context.read<UserProvider>();
    _loginProvider = context.read<UserLoginProvider>();
    _photoProvider = context.read<PhotoProvider>();
    _pickedFileNotifier = ValueNotifier<File?>(_pickedFile);
    loadUser();
  }

  void loadUser() async {
    var id = _loginProvider.getUserId();
    try {
      var usersResponse = await userProvider.getById(id!);
      setState(() {
        user = usersResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void editProfile() async {
    try {
      Map<String, dynamic> userData = {
        "Id": user!.id.toString(),
        "FirstName": _firstNameController.text,
        "LastName": _lastNameController.text,
        "Email": _emailController.text,
        "PhoneNumber": _phoneNumberController.text,
        'Gender': user!.gender.toString(),
        'DateOfBirth': user!.dateOfBirth,
        'Role': '1',
        'LastSignInAt': DateTime.now().toUtc().toIso8601String(),
        'IsVerified': user!.isVerified.toString(),
        'IsActive': user!.isActive.toString(),
      };
      if (_pickedFile != null) {
        userData['ProfilePhoto'] = http.MultipartFile.fromBytes(
          'ProfilePhoto',
          _pickedFile!.readAsBytesSync(),
          filename: 'profile_photo.jpg',
        );
      }
      var userEdited = await userProvider.editUserProfile(userData);
      if (userEdited == "OK") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Color(0XFF12B422),
              content: Text('Uspješno uređen profil.',
                  style: TextStyle(
                    color: Colors.white,
                  ))),
        );
      }
      setState(() {
        user = userEdited as User;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  Future<String> loadPhoto(String guidId) async {
    return await _photoProvider.getPhoto(guidId);
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _pickedFile = File(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    user = context.watch<UserProvider>().user;
    if (user == null) {
      return _buildLoadingIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit profile',
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Center(child: EditProfileWidget()),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.teal,
          body: Center(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget EditProfileWidget() {
    return Form(
      key: _formKey,
      child: Container(
        width: 400,
        margin: const EdgeInsets.all(24),
        child: Column(children: [
          ValueListenableBuilder<File?>(
              valueListenable: _pickedFileNotifier,
              builder: (context, pickedFile, _) {
                return FutureBuilder<String>(
                  future: user?.photo?.guidId != null
                      ? loadPhoto(user!.photo!.guidId!)
                      : null,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text(
                        'Molimo odaberite fotografiju',
                        style: TextStyle(color: Colors.white),
                      );
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
                            'assets/images/notFound.png',
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                    }
                  },
                );
              }),
          const SizedBox(
            height: 10.0,
          ),
          SizedBox(
            width: 130,
            child: ElevatedButton(
              onPressed: () => _pickImage(),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Change picture"),
            ),
          ),
          TextFormField(
            controller: _firstNameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Unesite ime!';
              }
              return null;
            },
            decoration: const InputDecoration(label: Text("FirstName")),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _lastNameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Unesite prezime!';
              }
              return null;
            },
            decoration: const InputDecoration(label: Text("LastName")),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Unesite email!';
              }
              return null;
            },
            decoration: const InputDecoration(label: Text("Email")),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _phoneNumberController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Unesite broj!';
              }
              return null;
            },
            decoration: const InputDecoration(label: Text("PhoneNumber")),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  editProfile();
                }
              },
              child: const Text("Save changes")),
        ]),
      ),
    );
  }
}

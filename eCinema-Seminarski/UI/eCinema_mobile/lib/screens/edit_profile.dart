// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:ecinema_mobile/models/login_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

import '../models/user.dart';
import '../providers/login_provider.dart';
import '../providers/photo_provider.dart';
import '../providers/user_provider.dart';
import '../utils/authorization.dart';
import '../utils/error_dialog.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/editprofile';

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  ValueNotifier<File?> _pickedFileNotifier = ValueNotifier(null);

  User? user;
  UserLogin? loginUser;
  DateTime selectedDate = DateTime.now();

  late UserProvider _userProvider;
  late UserLoginProvider _loginProvider;
  late PhotoProvider _photoProvider;

  int? selectedGender;
  int? selectedRole;
  File? _pickedFile;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _loginProvider = context.read<UserLoginProvider>();
    _photoProvider = context.read<PhotoProvider>();
    _pickedFileNotifier = ValueNotifier<File?>(_pickedFile);
    _loadUser();
  }

  Future<void> _loadUser() async {
    final id = _loginProvider.getUserId();
    loginUser = _loginProvider.user;

    try {
      final fetchedUser = await _userProvider.getById(id!);
      setState(() {
        user = fetchedUser;
        _firstNameController.text = fetchedUser.firstName;
        _lastNameController.text = fetchedUser.lastName;
        _emailController.text = fetchedUser.email;
        _phoneNumberController.text = fetchedUser.phoneNumber ?? '';
        selectedGender = fetchedUser.gender;
        selectedRole = fetchedUser.role;

        if (fetchedUser.birthDate != null && fetchedUser.birthDate!.isNotEmpty) {
          final parsedDate = DateTime.tryParse(fetchedUser.birthDate!)?.toLocal();
          if (parsedDate != null) {
            _birthDateController.text = DateFormat('yyyy-MM-dd').format(parsedDate);
            selectedDate = parsedDate;
          }
        }
      });
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  Future<String> loadPhoto(String guidId) async {
    return await _photoProvider.getPhoto(guidId);
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _pickedFileNotifier.value = File(pickedFile.path);
      _pickedFile = File(pickedFile.path);
    }
  }

  void _editUser() async {
    if (user == null) return;
    try {
      Map<String, dynamic> userData = {
        "Id": user!.id.toString(),
        'FirstName': _firstNameController.text,
        'LastName': _lastNameController.text,
        'Email': _emailController.text,
        'Password': _passwordController.text,
        'PhoneNumber': _phoneNumberController.text,
        'Gender': selectedGender.toString(),
        'BirthDate': DateTime.parse(_birthDateController.text).toUtc().toIso8601String(),
        'Role': user!.role.toString(),
        'IsVerified': true.toString(),
        'IsActive': true.toString(),
      };

      if (_pickedFile != null) {
        userData['ProfilePhoto'] = http.MultipartFile.fromBytes(
          'ProfilePhoto',
          _pickedFile!.readAsBytesSync(),
          filename: 'profile_photo.jpg',
        );
      }

      if (_pickedFile == null && user!.profilePhoto == null) {
        final ByteData data = await rootBundle.load('assets/images/notFound.png');
        List<int> bytes = data.buffer.asUint8List();

        userData['ProfilePhoto'] = http.MultipartFile.fromBytes(
          'ProfilePhoto',
          bytes,
          filename: 'notFound.png',
        );
      }

      var response = await _userProvider.updateUser(userData);

      if (response == "OK") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.teal,
            content: Text(
              'Uspješno uređen profil.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      } else {
        showErrorDialog(context, 'Greška prilikom uređivanja');
      }
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.teal)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile', textAlign: TextAlign.center),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            width: 400,
            margin: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ValueListenableBuilder<File?>(
                  valueListenable: _pickedFileNotifier,
                  builder: (context, pickedFile, _) {
                    if (pickedFile != null) {
                      return ClipOval(
                        child: Image.file(
                          pickedFile,
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      );
                    }

                    if (user?.profilePhoto?.guidId == null || user!.profilePhoto!.guidId!.isEmpty) {
                      return Image.asset('assets/images/user2.jpg', width: 110, height: 110);
                    }

                    return FutureBuilder<String>(
                      future: loadPhoto(user!.profilePhoto!.guidId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError || snapshot.data!.isEmpty) {
                          return Image.asset('assets/images/user2.jpg', width: 110, height: 110);
                        } else {
                          final imageUrl = '${snapshot.data}?v=${DateTime.now().millisecondsSinceEpoch}';
                          return ClipOval(
                            child: FadeInImage(
                              placeholder: MemoryImage(kTransparentImage),
                              image: NetworkImage(
                                imageUrl,
                                headers: Authorization.createHeaders(),
                              ),
                              fit: BoxFit.cover,
                              width: 110,
                              height: 110,
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 35),
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () => _pickImage(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Select An Image', style: TextStyle(fontSize: 11, color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                _buildTextFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFields() {
    return Column(
      children: [
        TextFormField(
          controller: _firstNameController,
          decoration: const InputDecoration(labelText: 'Ime'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Unesite ime!';
            }
            if (value.length < 2) {
              return 'Ime mora imati najmanje 2 slova!';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _lastNameController,
          decoration: const InputDecoration(labelText: 'Prezime'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Unesite prezime!';
            }
            if (value.length < 2) {
              return 'Prezime mora imati najmanje 2 slova!';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Unesite email!';
            }
            final emailPattern = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
            if (!emailPattern.hasMatch(value)) {
              return 'Unesite ispravan email!';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _phoneNumberController,
          decoration: const InputDecoration(labelText: 'Broj telefona'),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Unesite broj telefona!';
            }
            final phonePattern = RegExp(r'^[0-9 +()-]{6,15}$');
            if (!phonePattern.hasMatch(value)) {
              return 'Unesite ispravan broj telefona!';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _birthDateController,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Datum rođenja',
            hintText: 'Odaberite datum',
          ),
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());

            final safeInitialDate = selectedDate.isBefore(DateTime(1950)) ? DateTime(2000) : selectedDate;

            final date = await showDatePicker(
              context: context,
              initialDate: safeInitialDate,
              firstDate: DateTime(1950),
              lastDate: DateTime(2101),
            );

            if (date != null) {
              setState(() {
                selectedDate = date;
                _birthDateController.text = DateFormat('yyyy-MM-dd').format(date);
              });
            }
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Odaberite datum rođenja!';
            }
            return null;
          },
        ),
        DropdownButtonFormField<int>(
          value: selectedGender,
          onChanged: (newValue) => setState(() => selectedGender = newValue),
          items: const [
            DropdownMenuItem(value: 0, child: Text('Muški')),
            DropdownMenuItem(value: 1, child: Text('Ženski')),
          ],
          decoration: const InputDecoration(labelText: 'Spol'),
          validator: (value) {
            if (value == null) {
              return 'Odaberite spol!';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _editUser();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Padding(
            padding: EdgeInsets.all(2.0),
            child: Text("Save changes"),
          ),
        ),
      ],
    );
  }
}

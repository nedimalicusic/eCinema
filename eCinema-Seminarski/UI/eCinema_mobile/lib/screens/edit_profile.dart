import 'dart:io';
import 'package:ecinema_mobile/models/loginUser.dart';
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
  List<User> users = <User>[];
  List<User> selectedUsers = <User>[];
  late MediaQueryData mediaQueryData;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<File?> _pickedFileNotifier = ValueNotifier(null);

  final int userId = 0;
  User? user;
  UserLogin? loginUser;
  DateTime selectedDate = DateTime.now();
  late UserProvider _userProvider;
  late UserLoginProvider _loginProvider;
  bool isEditing = false;
  int? selectedGender;
  int? selectedRole;
  File? _pickedFile;

  File? selectedImage;
  late PhotoProvider _photoProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _loginProvider = context.read<UserLoginProvider>();
    _photoProvider = context.read<PhotoProvider>();
    loadUser();
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

  void loadUser() async {
    var id = _loginProvider.getUserId();
    loginUser = _loginProvider.user;
    try {
      var usersResponse = await _userProvider.getById(id!);
      setState(() {
        user = usersResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void editUser(int id) async {
    try {
      Map<String, dynamic> userData = {
        "Id": id.toString(),
        'FirstName': _firstNameController.text,
        'LastName': _lastNameController.text,
        'Email': _emailController.text,
        'Password': _passwordController.text,
        'PhoneNumber': _phoneNumberController.text,
        'Gender': selectedGender.toString(),
        'DateOfBirth':
            DateTime.parse(_birthDateController.text).toUtc().toIso8601String(),
        'Role': '1',
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
      if (_pickedFile == null && user!.photo == null) {
        final ByteData data =
            await rootBundle.load('assets/images/notFound.png');
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
              backgroundColor: Color(0XFF12B422),
              content: Text('Uspješno uređen profil.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ))),
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
      return _buildLoadingIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit profile',
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _buildForm(isEditing: true, userToEdit: user),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.teal),
    );
  }

  _setDate(DateTime date) {
    _birthDateController.text = DateFormat('yyyy-MM-dd').format(date);
  }

  Widget _buildForm({bool isEditing = false, User? userToEdit}) {
    if (userToEdit != null) {
      _firstNameController.text = userToEdit.firstName;
      _lastNameController.text = userToEdit.lastName;
      _emailController.text = userToEdit.email;
      _phoneNumberController.text = userToEdit.phoneNumber ?? '';
      _birthDateController.text = userToEdit.dateOfBirth ?? '';
      selectedRole = userToEdit.role;
      selectedGender = userToEdit.gender;
      _pickedFile = null;
    }
    return Form(
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
                return Container(
                  alignment: Alignment.center,
                  width: 140,
                  height: 140,
                  child: FutureBuilder<String>(
                    future: loginUser?.GuidId != null
                        ? loadPhoto(loginUser!.GuidId!)
                        : null,
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Please select an image');
                      } else {
                        final imageUrl = snapshot.data;

                        if (imageUrl != null && imageUrl.isNotEmpty) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: FadeInImage(
                              image: _pickedFile != null
                                  ? FileImage(_pickedFile!)
                                  : NetworkImage(
                                      imageUrl,
                                      headers: Authorization.createHeaders(),
                                    ) as ImageProvider<Object>,
                              placeholder: MemoryImage(kTransparentImage),
                              fadeInDuration: const Duration(milliseconds: 300),
                              fit: BoxFit.cover,
                              width: 230,
                              height: 200,
                            ),
                          );
                        } else {
                          return const Text('Please select an image');
                        }
                      }
                    },
                  ),
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
                  child: const Text('Select An Image',
                      style: TextStyle(fontSize: 11, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'Ime',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Unesite ime!';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Prezime',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Unesite prezime!';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Unesite email!';
                }
                final emailPattern = RegExp(r'^\w+@[\w-]+(\.[\w-]+)+$');
                if (!emailPattern.hasMatch(value)) {
                  return 'Unesite ispravan gmail email!';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Broj',
              ),
            ),
            TextFormField(
              controller: _birthDateController,
              decoration: const InputDecoration(
                labelText: 'Datum',
                hintText: 'Odaberite datum',
              ),
              onTap: () async {
                showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2101),
                ).then((date) {
                  if (date != null) {
                    selectedDate = date;

                    _setDate(date);
                  }
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Unesite datum!';
                }
                return null;
              },
            ),
            DropdownButtonFormField<int>(
              value: user!.gender,
              onChanged: (newValue) {
                setState(() {
                  user!.gender = newValue!;
                });
              },
              items: const [
                DropdownMenuItem<int>(
                  value: null,
                  child: Text(
                    'Odaberi spol',
                  ),
                ),
                DropdownMenuItem<int>(
                  value: 0,
                  child: Text(
                    'Muški',
                  ),
                ),
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text('Ženski'),
                ),
              ],
              decoration: const InputDecoration(
                labelText: 'Spol',
              ),
              validator: (value) {
                if (value == null) {
                  return 'Unesite spol!';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  editUser(user!.id);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(2.0),
                child: Text("Save changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

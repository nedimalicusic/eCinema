import 'package:flutter/material.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/error_dialog.dart';
import '../utils/success_dialog.dart';
import 'login_screen.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/editProfile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late UserProvider userProvider;
  late User? user;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userProvider = context.read<UserProvider>();
    user = userProvider.user;
    _firstNameController.text = user?.FirstName ?? '';
    _lastNameController.text = user?.LastName ?? '';
    _emailController.text = user?.Email ?? '';
    _phoneNumberController.text = user?.PhoneNumber ?? '';
  }

  void editProfile() async {
    try {
      var updatedUser = {
        "Id": user!.Id,
        "FirstName": _firstNameController.text,
        "LastName": _lastNameController.text,
        "Email": _emailController.text,
        "PhoneNumber": _phoneNumberController.text,
      };
      var userEdited = await userProvider.edit(updatedUser);
      if (userEdited =="OK") {
        showSuccessDialog(context, "Uspjesno ste editovali profil!");
      }
      setState(() {
        user = userEdited;
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
          const SizedBox(
            height: 50,
          ),
          Text(
            "Edit Profile",
            style: TextStyle(fontSize: 25, color: Colors.teal),
          ),
          Center(child: EditProfileWidget()),
        ],
      ),
    );
    ;
  }

  Widget EditProfileWidget() {
    return Container(
      child: Form(
        key: _formKey,
        child: Container(
          width: 400,
          margin: EdgeInsets.all(24),
          child: Column(children: [
            TextFormField(
              controller: _firstNameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Unesite ime!';
                }
                return null;
              },
              decoration: InputDecoration(label: Text("FirstName")),
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
              decoration: InputDecoration(label: Text("LastName")),
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
              decoration: InputDecoration(label: Text("Email")),
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
              decoration: InputDecoration(label: Text("PhoneNumber")),
            ),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      editProfile();
                    }
                  },
                  child: Text("Save Changes"))
            ])
          ]),
        ),
      ),
    );
  }
}

import 'package:ecinema_mobile/utils/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/error_dialog.dart';
import 'login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  static const routeName = '/changePassword';

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late UserProvider userProvider;
  late User? user;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userProvider = context.read<UserProvider>();
    user = userProvider.user;
  }

  void changePassword() async {
    try {
      var updatedUser = {
        "Id": user!.Id,
        "Password": _passwordController.text,
        "NewPassword": _newPasswordController.text,
        "ConfirmNewPassword": _confirmNewPasswordController.text,
      };
      var userEdited = await userProvider.chanagePassword(updatedUser);
      if (userEdited == "OK") {
        showSuccessDialog(context, "Uspjesno ste promijenili lozinku!");
      }
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
            "Change Password",
            style: TextStyle(fontSize: 25, color: Colors.teal),
          ),
          Center(child: ChangePasswordWidget()),
        ],
      ),
    );
  }

  Widget ChangePasswordWidget() {
    return Container(
      child: Form(
        key: _formKey,
        child: Container(
          width: 400,
          margin: EdgeInsets.all(24),
          child: Column(children: [
            TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Unesite staru šifru!';
                }
                return null;
              },
              decoration: InputDecoration(label: Text("Old password")),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _newPasswordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Unesite novi šifru!';
                }
                return null;
              },
              decoration: InputDecoration(label: Text("New password")),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _confirmNewPasswordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Potvrdite novu šifru!';
                }
                return null;
              },
              decoration: InputDecoration(label: Text("Confirm new password")),
            ),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      changePassword();
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

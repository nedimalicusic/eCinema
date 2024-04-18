// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:ecinema_mobile/providers/login_provider.dart';
import 'package:ecinema_mobile/utils/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/loginUser.dart';
import '../utils/error_dialog.dart';
import 'login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  static const routeName = '/changePassword';

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late UserLoginProvider userProvider;
  late UserLogin? user;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    userProvider = context.read<UserLoginProvider>();
    user = userProvider.user;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
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
          'Change password',
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(child: ChangePasswordWidget()),
        ],
      ),
    );
  }

  Widget ChangePasswordWidget() {
    return Form(
      key: _formKey,
      child: Container(
        width: 400,
        margin: const EdgeInsets.all(24),
        child: Column(children: [
          TextFormField(
            controller: _passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Unesite staru šifru!';
              }
              return null;
            },
            decoration: const InputDecoration(label: Text("Old password")),
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
            decoration: const InputDecoration(label: Text("New password")),
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
            decoration:
                const InputDecoration(label: Text("Confirm new password")),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  changePassword();
                }
              },
              child: const Text("Save changes")),
        ]),
      ),
    );
  }
}

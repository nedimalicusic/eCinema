// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:ecinema_mobile/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/login_user.dart';
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
  final TextEditingController _confirmNewPasswordController = TextEditingController();

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
        "Id": user!.id,
        "Password": _passwordController.text,
        "NewPassword": _newPasswordController.text,
        "ConfirmNewPassword": _confirmNewPasswordController.text,
      };
      var userEdited = await userProvider.chanagePassword(updatedUser);
      if (userEdited == "OK") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.teal,
            content: Text('Uspjesno ste promijenili lozinku!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ))));
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(child: ChangePasswordWidget()),
          ],
        ),
      ),
    );
  }

  Widget ChangePasswordWidget() {
    bool obscureOld = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    return StatefulBuilder(
      builder: (context, setState) {
        return Form(
          key: _formKey,
          child: Container(
            width: 400,
            margin: const EdgeInsets.all(24),
            child: Column(
              children: [
                TextFormField(
                  controller: _passwordController,
                  obscureText: obscureOld,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Unesite staru šifru!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Old password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureOld ? Icons.visibility_off : Icons.visibility,
                        color: Colors.teal,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureOld = !obscureOld;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: obscureNew,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Unesite novu šifru!';
                    }
                    if (value.length < 6) {
                      return 'Šifra mora imati najmanje 6 karaktera!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "New password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureNew ? Icons.visibility_off : Icons.visibility,
                        color: Colors.teal,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureNew = !obscureNew;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmNewPasswordController,
                  obscureText: obscureConfirm,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Potvrdite novu šifru!';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Šifre se ne podudaraju!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Confirm new password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirm ? Icons.visibility_off : Icons.visibility,
                        color: Colors.teal,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureConfirm = !obscureConfirm;
                        });
                      },
                    ),
                  ),
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
                  child: const Text("Save changes"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

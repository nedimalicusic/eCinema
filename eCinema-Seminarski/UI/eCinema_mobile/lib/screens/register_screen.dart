import 'package:ecinema_mobile/models/register.dart';
import 'package:ecinema_mobile/providers/login_provider.dart';
import 'package:ecinema_mobile/screens/login_screen.dart';
import 'package:ecinema_mobile/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const routeName = '/signUp';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late UserLoginProvider _userProvider;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserLoginProvider>();
  }

  void register() async {
    try {
      var registerData = Register(
        password: _passwordController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phoneNumber: _phoneNumberController.text,
      );

      await _userProvider.registerAsync(registerData);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.lightBlueAccent,
              content: Text('Registracija uspješna.',
                  style: TextStyle(
                    color: Colors.white,
                  ))),
        );
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.routeName, (route) => false);
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.slow_motion_video_rounded,
                      color: Colors.teal,
                      size: 36,
                      weight: 10,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "eCinema",
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _firstNameController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Unesite ime!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "First Name",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lastNameController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Unesite prezime!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Last Name",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Unesite vaš email.';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Unesite validan email.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Unesite broj telefona!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Phone",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Unesite šifru!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.password_outlined),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: _obscurePassword
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already hava an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    },
                    child: const Text("Sign In"),
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        register();
                      }
                    },
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

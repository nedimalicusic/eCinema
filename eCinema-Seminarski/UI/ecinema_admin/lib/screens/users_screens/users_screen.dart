// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:io';
import 'package:ecinema_admin/models/user.dart';
import 'package:ecinema_admin/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../helpers/constants.dart';
import '../../models/searchObject/user_search.dart';
import '../../providers/photo_provider.dart';
import '../../utils/authorzation.dart';
import '../../utils/error_dialog.dart';
import 'package:http/http.dart' as http;

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<User> users = <User>[];
  List<User> selectedUsers = <User>[];
  late UserProvider _userProvider;
  late PhotoProvider _photoProvider;
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  late ValueNotifier<bool> _isActiveNotifier;
  late ValueNotifier<bool> _isVerifiedNotifier;
  ValueNotifier<File?> _pickedFileNotifier = ValueNotifier(null);
  DateTime selectedDate = DateTime.now();
  String _selectedIsActive = 'Svi';
  String _selectedIsVerified = 'Svi';
  int? selectedGender;
  int? selectedCinemaId;
  bool _isActive = false;
  bool _isVerified = false;
  bool isAllSelected = false;
  int currentPage = 1;
  int pageSize = 5;
  int hasNextPage = 0;
  File? _pickedFile;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _photoProvider = context.read<PhotoProvider>();
    _isActiveNotifier = ValueNotifier<bool>(_isActive);
    _isVerifiedNotifier = ValueNotifier<bool>(_isVerified);
    _pickedFileNotifier = ValueNotifier<File?>(_pickedFile);

    loadUsers(
      UserSearchObject(
          name: _searchController.text,
          pageSize: pageSize,
          pageNumber: currentPage),
      _selectedIsActive,
      _selectedIsVerified,
    );

    _searchController.addListener(() {
      final searchQuery = _searchController.text;
      loadUsers(
          UserSearchObject(
              name: searchQuery, pageNumber: currentPage, pageSize: pageSize),
          _selectedIsActive,
          _selectedIsVerified);
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _pickedFileNotifier.value = File(pickedFile.path);
      _pickedFile = File(pickedFile.path);
    }
  }

  void loadUsers(UserSearchObject searchObject, String selectedIsActive,
      String selectedIsVerified) async {
    searchObject.isActive = selectedIsActive == 'Aktivni'
        ? true
        : selectedIsActive == 'Neaktivni'
            ? false
            : null;

    searchObject.isVerified = selectedIsVerified == 'Verifikovani'
        ? true
        : selectedIsVerified == 'Neverifikovani'
            ? false
            : null;

    try {
      var usersResponse =
          await _userProvider.getPaged(searchObject: searchObject);
      setState(() {
        users = usersResponse;
        hasNextPage = users.length;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  Future<String> loadPhoto(String guidId) async {
    return await _photoProvider.getPhoto(guidId);
  }

  void insertUser() async {
    try {
      if (_pickedFile == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Alert'),
              content: const Text('Please select an image.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      Map<String, dynamic> userData = {
        "Id": null,
        'FirstName': _firstNameController.text,
        'LastName': _lastNameController.text,
        'Email': _emailController.text,
        'Password': _passwordController.text,
        'PhoneNumber': _phoneNumberController.text,
        'Gender': selectedGender.toString(),
        'DateOfBirth':
            DateTime.parse(_birthDateController.text).toUtc().toIso8601String(),
        'Role': '1',
        'LastSignInAt': DateTime.now().toUtc().toIso8601String(),
        'IsVerified': _isVerified.toString(),
        'IsActive': _isActive.toString(),
      };

      userData['ProfilePhoto'] = http.MultipartFile.fromBytes(
        'ProfilePhoto',
        _pickedFile!.readAsBytesSync(),
        filename: 'profile_photo.jpg',
      );

      var response = await _userProvider.insertUser(userData);

      if (response == "OK") {
        Navigator.of(context).pop();
        loadUsers(
          UserSearchObject(
            name: _searchController.text,
            gender: null,
            isActive: null,
            isVerified: null,
            pageNumber: currentPage,
            pageSize: pageSize,
          ),
          _selectedIsActive,
          _selectedIsVerified,
        );
        setState(() {
          selectedGender = null;
        });
      } else {
        showErrorDialog(context, 'Greška prilikom dodavanja');
      }
    } catch (e) {
      showErrorDialog(context, e.toString());
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
        'LastSignInAt': DateTime.now().toUtc().toIso8601String(),
        'IsVerified': _isVerified.toString(),
        'IsActive': _isActive.toString(),
      };
      if (_pickedFile != null) {
        userData['ProfilePhoto'] = http.MultipartFile.fromBytes(
          'ProfilePhoto',
          _pickedFile!.readAsBytesSync(),
          filename: 'profile_photo.jpg',
        );
      }
      var response = await _userProvider.updateUser(userData);

      if (response == "OK") {
        Navigator.of(context).pop();
        loadUsers(
          UserSearchObject(
            name: _searchController.text,
            gender: null,
            isActive: null,
            isVerified: null,
            pageNumber: currentPage,
            pageSize: pageSize,
          ),
          _selectedIsActive,
          _selectedIsVerified,
        );
        setState(() {
          selectedGender = null;
        });
      } else {
        showErrorDialog(context, 'Greška prilikom uređivanja');
      }
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  void DeleteUser(int id) async {
    try {
      var user = await _userProvider.delete(id);
      if (user == "OK") {
        loadUsers(UserSearchObject(name: _searchController.text),
            _selectedIsActive, _selectedIsVerified);
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Korisnici"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              buildFilterDropdowns(),
              const SizedBox(height: 16.0),
              BuildSearchField(context),
              const SizedBox(
                height: 10,
              ),
              buildDataList(context),
              const SizedBox(
                height: 10,
              ),
              buildPagination(),
            ])));
  }

  Row BuildSearchField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.teal),
              borderRadius: BorderRadius.circular(10.0),
            ),
            width: 350,
            height: 40,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 4.0, left: 10.0),
                hintText: "Pretraga",
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                suffixIcon: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(defaultPadding * 0.25),
                    margin: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/Search.svg",
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
            )),
        const SizedBox(
          width: 20,
        ),
        buildButtons(context),
      ],
    );
  }

  Row buildFilterDropdowns() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('  Spol:'),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DropdownButton<int>(
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  value: selectedGender,
                  items: <int?>[null, 0, 1].map((int? value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(value == null
                            ? 'Svi'
                            : value == 0
                                ? 'Muški'
                                : 'Ženski'),
                      ),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedGender = newValue;
                      loadUsers(
                          UserSearchObject(
                              gender: selectedGender,
                              name: _searchController.text,
                              pageNumber: currentPage,
                              pageSize: pageSize),
                          _selectedIsActive,
                          _selectedIsVerified);
                    });
                  },
                  underline: Container(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('  Aktivni računi:'),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("Aktivi racuni"),
                  value: _selectedIsActive,
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  items:
                      <String>['Svi', 'Aktivni', 'Neaktivni'].map((String a) {
                    return DropdownMenuItem<String>(
                      value: a,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(a),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedIsActive = newValue ?? 'Svi';
                    });
                    loadUsers(
                        UserSearchObject(
                            isActive: _selectedIsActive == 'Aktivni'
                                ? true
                                : _selectedIsActive == 'Neaktivni'
                                    ? false
                                    : null,
                            name: _searchController.text,
                            pageNumber: currentPage,
                            pageSize: pageSize),
                        _selectedIsActive,
                        _selectedIsVerified);
                  },
                  underline: const Text(""),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('  Verifikovani računi:'),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  value: _selectedIsVerified,
                  items: <String>['Svi', 'Verifikovani', 'Neverifikovani']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedIsVerified = newValue ?? 'Svi';
                    });
                    loadUsers(
                        UserSearchObject(
                            isVerified: _selectedIsVerified == 'Verifikovani'
                                ? true
                                : _selectedIsVerified == 'Neverifikovani'
                                    ? false
                                    : null,
                            name: _searchController.text,
                            pageNumber: currentPage,
                            pageSize: pageSize),
                        _selectedIsActive,
                        _selectedIsVerified);
                  },
                  underline: const Text(""),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: const Size(40, 40),
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text("Dodaj korisnika"),
                    content: SingleChildScrollView(
                      child: AddUserForm(),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isActive = false;
                              _isVerified = false;
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text("Zatvori",
                              style: TextStyle(color: white))),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              insertUser();
                              setState(() {
                                _isActive = false;
                                _isVerified = false;
                              });
                            }
                          },
                          child: const Text("Spremi",
                              style: TextStyle(color: white)))
                    ],
                  );
                });
          },
          child: const Icon(
            Icons.add_outlined,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 10.0),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor, minimumSize: const Size(40, 40)),
          onPressed: () {
            if (selectedUsers.isEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Upozorenje"),
                      content: const Text(
                          "Morate odabrati barem jednog klijenta za uređivanje"),
                      actions: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child:
                              const Text("OK", style: TextStyle(color: white)),
                        ),
                      ],
                    );
                  });
            } else if (selectedUsers.length > 1) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Upozorenje"),
                      content: const Text(
                          "Odaberite samo jednog klijenta kojeg želite urediti"),
                      actions: <Widget>[
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Ok",
                                style: TextStyle(color: white)))
                      ],
                    );
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text("Uredi klijenta"),
                      content: AddUserForm(
                          isEditing: true, userToEdit: selectedUsers[0]),
                      actions: <Widget>[
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor),
                            onPressed: () {
                              setState(() {
                                _isActive = false;
                                _isVerified = false;
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text("Zatvori",
                                style: TextStyle(color: white))),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor),
                            onPressed: () {
                              editUser(selectedUsers[0].id);
                              setState(() {
                                selectedUsers = [];
                                _isActive = false;
                                _isVerified = false;
                              });
                            },
                            child: const Text("Spremi",
                                style: TextStyle(color: white))),
                      ],
                    );
                  });
            }
          },
          child: const Icon(
            Icons.edit_outlined,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 10.0),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: const Size(40, 40),
          ),
          onPressed: selectedUsers.isEmpty
              ? () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: const Text("Upozorenje"),
                            content: const Text(
                                "Morate odabrati klijenta kojeg želite obrisati."),
                            actions: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("OK",
                                    style: TextStyle(color: white)),
                              ),
                            ]);
                      });
                }
              : () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Izbriši klijenta!"),
                          content: const SingleChildScrollView(
                            child: Text(
                                "Da li ste sigurni da želite obrisati klijenta?"),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Odustani",
                                  style: TextStyle(color: white)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                for (User n in selectedUsers) {
                                  DeleteUser(n.id);
                                }
                                Navigator.of(context).pop();
                              },
                              child: const Text("Obriši",
                                  style: TextStyle(color: white)),
                            ),
                          ],
                        );
                      });
                },
          child: const Icon(
            Icons.delete_forever_outlined,
            color: Colors.white,
            size: 18,
          ),
        ),
      ],
    );
  }

  Expanded buildDataList(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minWidth: MediaQuery.of(context).size.width),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.teal, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DataTable(
                dataRowHeight: 80,
                dataRowColor: MaterialStateProperty.all(
                    const Color.fromARGB(42, 241, 241, 241)),
                columns: [
                  DataColumn(
                      label: Checkbox(
                          value: isAllSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              isAllSelected = value ?? false;
                              for (var userItem in users) {
                                userItem.isSelected = isAllSelected;
                              }
                              if (!isAllSelected) {
                                selectedUsers.clear();
                              } else {
                                selectedUsers = List.from(users);
                              }
                            });
                          })),
                  const DataColumn(
                    label: Expanded(child: Text('Ime i prezime')),
                  ),
                  const DataColumn(
                    label: Text('Slika'),
                  ),
                  const DataColumn(
                    label: Expanded(child: Text('Broj telefona')),
                  ),
                  const DataColumn(
                    label: Text('Email'),
                  ),
                  const DataColumn(
                    label: Text('Spol'),
                  ),
                  const DataColumn(
                    label: Text('Aktivan'),
                  ),
                  const DataColumn(
                    label: Text('Verifikovan'),
                  ),
                ],
                rows: users
                    .map((User userItem) => DataRow(cells: [
                          DataCell(
                            Checkbox(
                              value: userItem.isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  userItem.isSelected = value ?? false;
                                  if (userItem.isSelected == true) {
                                    selectedUsers.add(userItem);
                                  } else {
                                    selectedUsers.remove(userItem);
                                  }
                                  isAllSelected =
                                      users.every((u) => u.isSelected);
                                });
                              },
                            ),
                          ),
                          DataCell(Text(
                              ("${userItem.firstName.toString()} ${userItem.lastName.toString()}"))),
                          DataCell(
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: FutureBuilder<String>(
                                    future: loadPhoto(
                                        userItem.profilePhoto?.guidId ?? ''),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return const Text(
                                            'Greška prilikom učitavanja slike');
                                      } else {
                                        final imageUrl = snapshot.data;

                                        if (imageUrl != null &&
                                            imageUrl.isNotEmpty) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: FadeInImage(
                                              image: NetworkImage(
                                                imageUrl,
                                                headers: Authorization
                                                    .createHeaders(),
                                              ),
                                              placeholder: MemoryImage(
                                                  kTransparentImage),
                                              fadeInDuration: const Duration(
                                                  milliseconds: 300),
                                              fit: BoxFit.fill,
                                              width: 80,
                                              height: 105,
                                            ),
                                          );
                                        } else {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Image.asset(
                                              'assets/images/user2.png',
                                              width: 80,
                                              height: 105,
                                              fit: BoxFit.fill,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(Center(
                            child: Text(userItem.phoneNumber?.toString() ?? ""),
                          )),
                          DataCell(Text(userItem.email.toString())),
                          DataCell(
                              Text(userItem.gender == 0 ? "Male" : "Female")),
                          DataCell(Container(
                            alignment: Alignment.center,
                            child: userItem.isActive == true
                                ? const Icon(
                                    Icons.check_circle_outline,
                                    color: green,
                                    size: 30,
                                  )
                                : const Icon(
                                    Icons.close_outlined,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                          )),
                          DataCell(Container(
                            alignment: Alignment.center,
                            child: userItem.isVerified == true
                                ? const Icon(
                                    Icons.check_circle_outline,
                                    color: green,
                                    size: 30,
                                  )
                                : const Icon(
                                    Icons.close_outlined,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                          )),
                        ]))
                    .toList()),
          ),
        ),
      ),
    );
  }

  Widget AddUserForm({bool isEditing = false, User? userToEdit}) {
    if (userToEdit != null) {
      _firstNameController.text = userToEdit.firstName;
      _lastNameController.text = userToEdit.lastName;
      _emailController.text = userToEdit.email;
      _phoneNumberController.text = userToEdit.phoneNumber ?? '';
      _birthDateController.text = userToEdit.birthDate;
      selectedGender = userToEdit.gender;
      _isActive = userToEdit.isActive;
      _isVerified = userToEdit.isVerified;
      _passwordController.text = '';
      _pickedFile = null;
    } else {
      _firstNameController.text = '';
      _lastNameController.text = '';
      _emailController.text = '';
      _phoneNumberController.text = '';
      _birthDateController.text = '';
      selectedGender = null;
      _isVerified = false;
      _isActive = false;
      _passwordController.text = '';
      _pickedFile = null;
    }

    return SizedBox(
      height: 450,
      width: 950,
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
                child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(35),
                child: Column(children: [
                  ValueListenableBuilder<File?>(
                      valueListenable: _pickedFileNotifier,
                      builder: (context, pickedFile, _) {
                        return Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 180,
                          color: Colors.teal,
                          child: FutureBuilder<String>(
                            future: _pickedFile != null
                                ? Future.value(_pickedFile!.path)
                                : loadPhoto(isEditing
                                    ? (userToEdit?.profilePhoto?.guidId ?? '')
                                    : ''),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return const Text(
                                  'Molimo odaberite fotografiju',
                                  style: TextStyle(color: Colors.white),
                                );
                              } else {
                                final imageUrl = snapshot.data;

                                if (imageUrl != null && imageUrl.isNotEmpty) {
                                  return FadeInImage(
                                    image: _pickedFile != null
                                        ? FileImage(_pickedFile!)
                                        : NetworkImage(
                                            imageUrl,
                                            headers:
                                                Authorization.createHeaders(),
                                          ) as ImageProvider<Object>,
                                    placeholder: MemoryImage(kTransparentImage),
                                    fadeInDuration:
                                        const Duration(milliseconds: 300),
                                    fit: BoxFit.cover,
                                    width: 230,
                                    height: 200,
                                  );
                                } else {
                                  return isEditing
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: const Text('Odaberite sliku'),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Image.asset(
                                            'assets/images/default_user_image.jpg',
                                            width: 230,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                }
                              }
                            },
                          ),
                        );
                      }),
                  const SizedBox(height: 35),
                  Center(
                    child: SizedBox(
                      width: 150,
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () => _pickImage(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text('Odaberite sliku',
                            style: TextStyle(fontSize: 12, color: white)),
                      ),
                    ),
                  )
                ]),
              ),
            )),
            const SizedBox(
              width: 30,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'Ime'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Unesite ime!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Prezime'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Unesite prezime!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
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
                    decoration: const InputDecoration(labelText: 'Broj'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Unesite broj!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Sifra'),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _birthDateController,
                    decoration: const InputDecoration(
                      labelText: 'Datum',
                      hintText: 'Odaberite datum',
                    ),
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2101),
                      ).then((date) {
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                            _birthDateController.text =
                                DateFormat('yyyy-MM-dd').format(date);
                          });
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
                    value: selectedGender,
                    onChanged: (newValue) {
                      setState(() {
                        selectedGender = newValue!;
                      });
                    },
                    items: const [
                      DropdownMenuItem<int>(
                        value: null,
                        child: Text('Odaberi spol'),
                      ),
                      DropdownMenuItem<int>(
                        value: 0,
                        child: Text('Muški'),
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
                  const SizedBox(
                    height: 20,
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isActiveNotifier,
                    builder: (context, isActive, child) {
                      return Row(
                        children: [
                          Checkbox(
                            value: _isActiveNotifier.value,
                            onChanged: (bool? value) {
                              _isActiveNotifier.value =
                                  !_isActiveNotifier.value;
                              _isActive = _isActiveNotifier.value;
                            },
                          ),
                          const Text('Aktivan'),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isVerifiedNotifier,
                    builder: (context, isVerified, child) {
                      return Row(
                        children: [
                          Checkbox(
                            value: _isVerifiedNotifier.value,
                            onChanged: (bool? value) {
                              _isVerifiedNotifier.value =
                                  !_isVerifiedNotifier.value;
                              _isVerified = _isVerifiedNotifier.value;
                            },
                          ),
                          const Text('Verifikovan'),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
          onPressed: () {
            if (currentPage > 1) {
              setState(() {
                currentPage--;
              });
              loadUsers(
                  UserSearchObject(
                    pageNumber: currentPage,
                    pageSize: pageSize,
                  ),
                  _selectedIsActive,
                  _selectedIsVerified);
            }
          },
          child: const Icon(
            Icons.arrow_left_outlined,
            color: white,
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
          onPressed: () {
            setState(() {
              if (hasNextPage == pageSize) {
                currentPage++;
              }
            });
            if (hasNextPage == pageSize) {
              loadUsers(
                  UserSearchObject(
                      pageNumber: currentPage,
                      pageSize: pageSize,
                      name: _searchController.text),
                  _selectedIsActive,
                  _selectedIsVerified);
            }
          },
          child: const Icon(
            Icons.arrow_right_outlined,
            color: white,
          ),
        ),
      ],
    );
  }
}

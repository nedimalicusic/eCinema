// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:io';
import 'package:ecinema_admin/models/employee.dart';
import 'package:ecinema_admin/models/searchObject/employee_search.dart';
import 'package:ecinema_admin/providers/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../helpers/constants.dart';
import '../../models/cinema.dart';
import '../../providers/cinema_provider.dart';
import '../../providers/photo_provider.dart';
import '../../utils/authorzation.dart';
import '../../utils/error_dialog.dart';
import 'package:http/http.dart' as http;

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({Key? key}) : super(key: key);

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  List<Employee> employees = <Employee>[];
  late EmployeeProvider _employeeProvider;
  late CinemaProvider _cinemaProvider;
  late PhotoProvider _photoProvider;
  List<Employee> selectedEmployee = <Employee>[];
  List<Cinema> cinemaList = <Cinema>[];
  Cinema? selectedCinema;
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  ValueNotifier<File?> _pickedFileNotifier = ValueNotifier(null);
  DateTime selectedDate = DateTime.now();
  late ValueNotifier<bool> _isActiveNotifier;
  int? selectedGender;
  int? selectedCinemaId;
  bool _isActive = false;
  String _selectedIsActive = 'Svi';
  bool isAllSelected = false;
  int currentPage = 1;
  int pageSize = 5;
  int hasNextPage = 0;
  File? _pickedFile;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _employeeProvider = context.read<EmployeeProvider>();
    _cinemaProvider = context.read<CinemaProvider>();
    _photoProvider = context.read<PhotoProvider>();
    _isActiveNotifier = ValueNotifier<bool>(_isActive);
    _pickedFileNotifier = ValueNotifier<File?>(_pickedFile);
    loadCinema();

    loadEmployee(
        EmployeeSearchObject(
            name: _searchController.text,
            cinemaId: selectedCinema?.id,
            pageSize: pageSize,
            pageNumber: currentPage),
        _selectedIsActive);

    _searchController.addListener(() {
      final searchQuery = _searchController.text;
      loadEmployee(
          EmployeeSearchObject(
              name: searchQuery, pageNumber: currentPage, pageSize: pageSize),
          _selectedIsActive);
    });
  }

  void loadEmployee(
      EmployeeSearchObject searchObject, String selectedIsActive) async {
    searchObject.isActive = selectedIsActive == 'Aktivni'
        ? true
        : selectedIsActive == 'Neaktivni'
            ? false
            : null;

    try {
      var employeeResponse =
          await _employeeProvider.getPaged(searchObject: searchObject);
      if (mounted) {
        setState(() {
          employees = employeeResponse;
          hasNextPage = employees.length;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _pickedFileNotifier.value = File(pickedFile.path);
      _pickedFile = File(pickedFile.path);
    }
  }

  Future<String> loadPhoto(String guidId) async {
    return await _photoProvider.getPhoto(guidId);
  }

  void loadCinema() async {
    try {
      var cinemasResponse = await _cinemaProvider.get(null);
      setState(() {
        cinemaList = cinemasResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void InsertEmployee() async {
    try {
      var newEmployee = {
        "FirstName": _firstNameController.text,
        "LastName": _lastNameController.text,
        "Email": _emailController.text,
        "BirthDate": _birthDateController.text,
        "Gender": selectedGender,
        "CinemaId": selectedCinemaId,
        "IsActive": _isActive
      };

      if (_pickedFile != null) {
        newEmployee['ProfilePhoto'] = http.MultipartFile.fromBytes(
          'ProfilePhoto',
          _pickedFile!.readAsBytesSync(),
          filename: 'profile_photo.jpg',
        );
      }

      var employee = await _employeeProvider.insertEmployee(newEmployee);
      if (employee == "OK") {
        Navigator.of(context).pop();
        loadEmployee(
          EmployeeSearchObject(
            name: _searchController.text,
            gender: null,
            isActive: null,
            cinemaId: null,
            pageNumber: currentPage,
            pageSize: pageSize,
          ),
          _selectedIsActive,
        );
        setState(() {
          selectedGender = null;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void EditEmployee(int id) async {
    try {
      var newEmployee = {
        "Id": id,
        "FirstName": _firstNameController.text,
        "LastName": _lastNameController.text,
        "Email": _emailController.text,
        "BirthDate": _birthDateController.text,
        "Gender": selectedGender,
        "CinemaId": selectedCinemaId,
        "IsActive": _isActive
      };

      if (_pickedFile != null) {
        newEmployee['ProfilePhoto'] = http.MultipartFile.fromBytes(
          'ProfilePhoto',
          _pickedFile!.readAsBytesSync(),
          filename: 'profile_photo.jpg',
        );
      }

      var employee = await _employeeProvider.updateEmployee(newEmployee);
      if (employee == "OK") {
        Navigator.of(context).pop();
        loadEmployee(
          EmployeeSearchObject(
            name: _searchController.text,
            gender: null,
            isActive: null,
            cinemaId: null,
            pageNumber: currentPage,
            pageSize: pageSize,
          ),
          _selectedIsActive,
        );
        setState(() {
          selectedGender = null;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void DeleteEmployee(int id) async {
    try {
      var employee = await _employeeProvider.delete(id);
      if (employee == "OK") {
        loadEmployee(
          EmployeeSearchObject(
            name: _searchController.text,
            gender: null,
            isActive: null,
            pageNumber: currentPage,
            pageSize: pageSize,
          ),
          _selectedIsActive,
        );
        setState(() {
          selectedGender = null;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Uposlenici"),
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
                    padding: const EdgeInsets.all(defaultPadding * 0.75),
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
              const Text('  Pretraga po kinima:'),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DropdownButton<Cinema>(
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  value: selectedCinema,
                  items: [
                    const DropdownMenuItem<Cinema>(
                      value: null,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('Svi'),
                      ),
                    ),
                    ...cinemaList.map((Cinema cinema) {
                      return DropdownMenuItem<Cinema>(
                        value: cinema,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(cinema.name),
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: (Cinema? newValue) {
                    setState(() {
                      selectedCinema = newValue;
                    });
                    if (selectedCinema == null) {
                      loadEmployee(
                        EmployeeSearchObject(
                          cinemaId: null,
                          name: _searchController.text,
                          pageNumber: currentPage,
                          pageSize: pageSize,
                        ),
                        _selectedIsActive,
                      );
                    } else {
                      loadEmployee(
                        EmployeeSearchObject(
                          cinemaId: selectedCinema!.id,
                          name: _searchController.text,
                          pageNumber: currentPage,
                          pageSize: pageSize,
                        ),
                        _selectedIsActive,
                      );
                    }
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
                      loadEmployee(
                        EmployeeSearchObject(
                            gender: selectedGender,
                            name: _searchController.text,
                            pageNumber: currentPage,
                            pageSize: pageSize),
                        _selectedIsActive,
                      );
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
                    loadEmployee(
                        EmployeeSearchObject(
                            isActive: _selectedIsActive == 'Aktivni'
                                ? true
                                : _selectedIsActive == 'Neaktivni'
                                    ? false
                                    : null,
                            name: _searchController.text,
                            pageNumber: currentPage,
                            pageSize: pageSize),
                        _selectedIsActive);
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
                    title: const Text("Dodaj uposlenika"),
                    content: SingleChildScrollView(
                      child: AddEmployeeForm(),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isActive = false;
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
                              InsertEmployee();
                              setState(() {
                                _isActive = false;
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
          ),
        ),
        const SizedBox(width: 10.0),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: const Size(40, 40),
          ),
          onPressed: () {
            if (selectedEmployee.isEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Upozorenje"),
                      content: const Text(
                          "Morate odabrati barem jednog uposlenika za uređivanje"),
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
            } else if (selectedEmployee.length > 1) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Upozorenje"),
                      content: const Text(
                          "Odaberite samo jednog uposlenika kojeg želite urediti"),
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
                      title: const Text("Uredi uposlenika"),
                      content: AddEmployeeForm(
                          isEditing: true, employeeToEdit: selectedEmployee[0]),
                      actions: <Widget>[
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor),
                            onPressed: () {
                              setState(() {
                                _isActive = false;
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text("Zatvori",
                                style: TextStyle(color: white))),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor),
                            onPressed: () {
                              EditEmployee(selectedEmployee[0].id);
                              setState(() {
                                selectedEmployee = [];
                                _isActive = false;
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
          ),
        ),
        const SizedBox(width: 10.0),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: const Size(40, 40),
          ),
          onPressed: selectedEmployee.isEmpty
              ? () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: const Text("Upozorenje"),
                            content: const Text(
                                "Morate odabrati uposlenika kojeg želite obrisati."),
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
                          title: const Text("Izbriši uposlenika!"),
                          content: const SingleChildScrollView(
                            child: Text(
                                "Da li ste sigurni da želite obrisati uposlenika?"),
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
                                for (Employee n in selectedEmployee) {
                                  DeleteEmployee(n.id);
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
          ),
        ),
      ],
    );
  }

  Widget AddEmployeeForm({bool isEditing = false, Employee? employeeToEdit}) {
    if (employeeToEdit != null) {
      _firstNameController.text = employeeToEdit.firstName;
      _lastNameController.text = employeeToEdit.lastName;
      _emailController.text = employeeToEdit.email;
      _birthDateController.text = employeeToEdit.birthDate;
      selectedCinemaId = employeeToEdit.cinemaId;
      selectedGender = employeeToEdit.gender;
      _isActive = employeeToEdit.isActive;
    } else {
      _firstNameController.text = '';
      _lastNameController.text = '';
      _emailController.text = '';
      _birthDateController.text = '';
      selectedGender = null;
      selectedCinemaId = null;
      _isActive = false;
    }

    return SizedBox(
      height: 450,
      width: 900,
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
                                    ? (employeeToEdit?.profilePhoto?.guidId ??
                                        '')
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
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text('Odaberite sliku',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
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
                  DropdownButtonFormField<int>(
                    value: selectedCinemaId,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedCinemaId = newValue;
                      });
                    },
                    items: cinemaList.map((Cinema cinema) {
                      return DropdownMenuItem<int>(
                        value: cinema.id,
                        child: Text(cinema.name),
                      );
                    }).toList(),
                    decoration: const InputDecoration(labelText: 'Kino'),
                    validator: (value) {
                      if (value == null) {
                        return 'Odaberite kino!';
                      }
                      return null;
                    },
                  ),
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
                      hintText: 'Odaberite datum', // Dodajte hintText ovde
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
                ],
              ),
            ),
          ],
        ),
      ),
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
                              for (var employeeItem in employees) {
                                employeeItem.isSelected = isAllSelected;
                              }
                              if (!isAllSelected) {
                                selectedEmployee.clear();
                              } else {
                                selectedEmployee = List.from(employees);
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
                    label: Text('Email'),
                  ),
                  const DataColumn(
                    label: Text('Spol'),
                  ),
                  const DataColumn(
                    label: Text('Aktivan'),
                  ),
                ],
                rows: employees
                    .map((Employee employeeItem) => DataRow(cells: [
                          DataCell(
                            Checkbox(
                              value: employeeItem.isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  employeeItem.isSelected = value ?? false;
                                  if (employeeItem.isSelected == true) {
                                    selectedEmployee.add(employeeItem);
                                  } else {
                                    selectedEmployee.remove(employeeItem);
                                  }
                                  isAllSelected =
                                      employees.every((u) => u.isSelected);
                                });
                              },
                            ),
                          ),
                          DataCell(Text(
                              ("${employeeItem.firstName.toString()} ${employeeItem.lastName.toString()}"))),
                          DataCell(
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: FutureBuilder<String>(
                                    future: loadPhoto(
                                        employeeItem.profilePhoto?.guidId ??
                                            ''),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
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
                                              width: 80,
                                              height: 105,
                                              fit: BoxFit.fill,
                                            ),
                                          );
                                        } else {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Image.asset(
                                              'assets/images/user2.png',
                                              width: 80,
                                              height: 80,
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
                          DataCell(Text(employeeItem.email.toString())),
                          DataCell(Text(
                              employeeItem.gender == 0 ? "Muško" : "Žensko")),
                          DataCell(Container(
                            alignment: Alignment.center,
                            child: employeeItem.isActive == true
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
              loadEmployee(
                  EmployeeSearchObject(
                    pageNumber: currentPage,
                    pageSize: pageSize,
                  ),
                  _selectedIsActive);
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
              loadEmployee(
                  EmployeeSearchObject(
                      pageNumber: currentPage,
                      pageSize: pageSize,
                      name: _searchController.text),
                  _selectedIsActive);
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

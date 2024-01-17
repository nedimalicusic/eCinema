// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:ecinema_admin/models/actor.dart';
import 'package:ecinema_admin/providers/actor_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/error_dialog.dart';

class ActorsScreen extends StatefulWidget {
  const ActorsScreen({Key? key}) : super(key: key);

  @override
  State<ActorsScreen> createState() => _ActorsScreenState();
}

class _ActorsScreenState extends State<ActorsScreen> {
  List<Actor> actors = <Actor>[];
  late ActorProvider _actorProvider;
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  int? selectedGender;
  @override
  void initState() {
    super.initState();
    _actorProvider = context.read<ActorProvider>();
    loadActors('');
    _searchController.addListener(() {
      final searchQuery = _searchController.text;
      loadActors(searchQuery);
    });
  }

  void loadActors(String? query) async {
    var params;
    try {
      if (query != null) {
        params = query;
      } else {
        params = null;
      }
      var actorsResponse = await _actorProvider.get({'params': params});
      setState(() {
        actors = actorsResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void InsertActor() async {
    try {
      var newActor = {
        "firstName": _firstNameController.text,
        "lastName": _lastNameController.text,
        "email": _emailController.text,
        "birthDate": _birthDateController.text,
        "gender": selectedGender
      };
      var city = await _actorProvider.insert(newActor);
      if (city == "OK") {
        Navigator.of(context).pop();
        loadActors('');
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void EditActor(int id) async {
    try {
      var newActor = {
        "id": id,
        "firstName": _firstNameController.text,
        "lastName": _lastNameController.text,
        "email": _emailController.text,
        "birthDate": _birthDateController.text,
        "gender": selectedGender
      };
      var city = await _actorProvider.edit(newActor);
      if (city == "OK") {
        Navigator.of(context).pop();
        loadActors('');
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void DeleteActor(int id) async {
    try {
      var actor = await _actorProvider.delete(id);
      if (actor == "OK") {
        Navigator.of(context).pop();
        loadActors('');
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 1200,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 500,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 136,
                          top: 8,
                          right: 8), // Margine za input polje
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Pretraga',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 146),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Dodaj glumca'),
                              content: SingleChildScrollView(
                                child: AddActorForm(),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Zatvori'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      InsertActor();
                                    }
                                  },
                                  child: const Text('Spremi'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text("Dodaj"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDataListView()
            ],
          ),
        ),
      ),
    );
  }

  Widget AddActorForm({bool isEditing = false, Actor? actorToEdit}) {
    if (actorToEdit != null) {
      _firstNameController.text = actorToEdit.firstName;
      _lastNameController.text = actorToEdit.lastName;
      _emailController.text = actorToEdit.email;
      _birthDateController.text = actorToEdit.birthDate;
      selectedGender = actorToEdit.gender;
    } else {
      _firstNameController.text = '';
      _lastNameController.text = '';
      _emailController.text = '';
      _birthDateController.text = '';
      selectedGender = null;
    }

    return SizedBox(
      height: 400,
      width: 350,
      child: Form(
        key: _formKey,
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
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDataListView() {
    return Expanded(
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
              columns: const [
                DataColumn(
                    label: Expanded(
                  flex: 2,
                  child: Text(
                    "ID",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  flex: 5,
                  child: Text(
                    "FirstName",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  flex: 4,
                  child: Text(
                    "LastName",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  flex: 4,
                  child: Text(
                    "Email",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  flex: 4,
                  child: Text(
                    "BirthDate",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  flex: 4,
                  child: Text(
                    "Gender",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  flex: 2,
                  child: Text(
                    "",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  flex: 2,
                  child: Text(
                    "",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                )),
              ],
              rows: actors
                  .map((Actor e) => DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(e.firstName.toString())),
                        DataCell(Text(e.lastName.toString())),
                        DataCell(Text(e.email.toString())),
                        DataCell(Text(DateFormat('dd.MM.yyyy')
                            .format(DateTime.parse(e.birthDate))
                            .toString())),
                        DataCell(Text(e.gender == 0 ? "Male" : "Female")),
                        DataCell(
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isEditing = true;
                              });
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(isEditing
                                        ? 'Uredi glumaca'
                                        : 'Dodaj glumca'),
                                    content: SingleChildScrollView(
                                      child: AddActorForm(
                                          isEditing: isEditing, actorToEdit: e),
                                    ),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Zatvori'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            EditActor(e.id);
                                          }
                                        },
                                        child: const Text('Spremi'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text("Edit"),
                          ),
                        ),
                        DataCell(
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Izbrisi glumca"),
                                    content: const SingleChildScrollView(
                                        child: Text(
                                            "Da li ste sigurni da zelite obisati glumca?")),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Odustani'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          DeleteActor(e.id);
                                        },
                                        child: const Text('Izbrisi'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text("Delete"),
                          ),
                        ),
                      ]))
                  .toList())),
    );
  }
}

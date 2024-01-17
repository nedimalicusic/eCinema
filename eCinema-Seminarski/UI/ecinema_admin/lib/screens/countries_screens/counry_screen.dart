// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:ecinema_admin/models/country.dart';
import 'package:ecinema_admin/providers/country_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/error_dialog.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({Key? key}) : super(key: key);

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Country> countries = <Country>[];
  late CountryProvider _countryProvider;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _abbrevationContoller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  late ValueNotifier<bool> _isActiveNotifier;
  bool isEditing = false;
  bool _countryIsActive = false;

  @override
  void initState() {
    super.initState();
    _countryProvider = context.read<CountryProvider>();
    _isActiveNotifier = ValueNotifier<bool>(_countryIsActive);
    loadCountries('');
    _searchController.addListener(() {
      final searchQuery = _searchController.text;
      loadCountries(searchQuery);
    });
  }

  void loadCountries(String? query) async {
    var params;
    try {
      if (query != null) {
        params = query;
      } else {
        params = null;
      }
      var countriesResponse = await _countryProvider.get({'params': params});
      setState(() {
        countries = countriesResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void InsertCountry() async {
    try {
      var newCountry = {
        "name": _nameController.text,
        "abbreviation": _abbrevationContoller.text,
        "isActive": _countryIsActive,
      };
      var country = await _countryProvider.insert(newCountry);
      if (country == "OK") {
        Navigator.of(context).pop();
        loadCountries('');
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void DeleteCounty(int id) async {
    try {
      var country = await _countryProvider.delete(id);
      if (country == "OK") {
        Navigator.of(context).pop();
        loadCountries('');
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void EditCountry(int id) async {
    try {
      var newCountry = {
        "id": id,
        "name": _nameController.text,
        "abbreviation": _abbrevationContoller.text,
        "isActive": _countryIsActive,
      };
      var country = await _countryProvider.edit(newCountry);
      if (country == "OK") {
        Navigator.of(context).pop();
        loadCountries('');
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
          width: 1100,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 500,
                    child: Padding(
                        padding:
                            const EdgeInsets.only(left: 136, top: 8, right: 8),
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Pretraga',
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 146),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Dodaj državu'),
                              content: SingleChildScrollView(
                                child: AddCountryForm(),
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
                                      InsertCountry();
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

  Widget AddCountryForm({bool isEditing = false, Country? countryToEdit}) {
    if (countryToEdit != null) {
      _nameController.text = countryToEdit.name;
      _abbrevationContoller.text = countryToEdit.abbreviation;
      _isActiveNotifier.value = countryToEdit.isActive;
    } else {
      _nameController.text = '';
      _abbrevationContoller.text = '';
      _countryIsActive = false;
    }

    return SizedBox(
      height: 250,
      width: 300,
      child: (Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Naziv države'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Unesite naziv države';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _abbrevationContoller,
              decoration: const InputDecoration(labelText: 'Skraćenica'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Unesite kod države';
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
                        _isActiveNotifier.value = !_isActiveNotifier.value;
                        _countryIsActive = _isActiveNotifier.value;
                      },
                    ),
                    const Text('Aktivan'),
                  ],
                );
              },
            ),
          ],
        ),
      )),
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
                    "Name",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  flex: 4,
                  child: Text(
                    "Abbreviation",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  flex: 4,
                  child: Text(
                    "Active",
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
              rows: countries
                  .map((Country e) => DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(e.name.toString())),
                        DataCell(Text(e.abbreviation.toString())),
                        DataCell(Text(e.isActive.toString())),
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
                                        ? 'Uredi državu'
                                        : 'Dodaj državu'),
                                    content: SingleChildScrollView(
                                      child: AddCountryForm(
                                          isEditing: isEditing,
                                          countryToEdit: e),
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
                                            EditCountry(e.id);
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
                                    title: const Text("Izbrisi drzavu"),
                                    content: const SingleChildScrollView(
                                        child: Text(
                                            "Da li ste sigurni da zelite obisati drzavu?")),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Odustani'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          DeleteCounty(e.id);
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

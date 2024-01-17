// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:ecinema_admin/models/city.dart';
import 'package:ecinema_admin/models/country.dart';
import 'package:ecinema_admin/providers/city_provider.dart';
import 'package:ecinema_admin/providers/country_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/error_dialog.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({Key? key}) : super(key: key);

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  final _formKey = GlobalKey<FormState>();
  List<City> cities = <City>[];
  List<Country> countries = <Country>[];
  late CityProvider _cityProvider;
  late CountryProvider _countryProvider;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  late ValueNotifier<bool> _isActiveNotifier;
  bool isEditing = false;
  int? _selectedCountryId;
  bool _cityIsActive = false;

  @override
  void initState() {
    super.initState();
    _cityProvider = context.read<CityProvider>();
    _countryProvider = context.read<CountryProvider>();
    _isActiveNotifier = ValueNotifier<bool>(_cityIsActive);
    loadCities('');
    loadCountries();
    _searchController.addListener(() {
      final searchQuery = _searchController.text;
      loadCities(searchQuery);
    });
  }

  void loadCities(String? query) async {
    var params;
    try {
      if (query != null) {
        params = query;
      } else {
        params = null;
      }
      var citiesResponse = await _cityProvider.get({'params': params});
      setState(() {
        cities = citiesResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadCountries() async {
    try {
      var countriesResponse = await _countryProvider.get(null);
      setState(() {
        countries = countriesResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void InsertCity() async {
    try {
      var newCity = {
        "name": _nameController.text,
        "zipCode": _zipCodeController.text,
        "countryId": _selectedCountryId,
        "isActive": _cityIsActive
      };
      var city = await _cityProvider.insert(newCity);
      if (city == "OK") {
        Navigator.of(context).pop();
        loadCities('');
        setState(() {
          _selectedCountryId = null;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void EditCity(int id) async {
    try {
      var newCity = {
        "id": id,
        "name": _nameController.text,
        "zipCode": _zipCodeController.text,
        "countryId": _selectedCountryId,
        "isActive": _cityIsActive
      };
      var city = await _cityProvider.edit(newCity);
      if (city == "OK") {
        Navigator.of(context).pop();
        loadCities('');
        setState(() {
          _selectedCountryId = null;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void DeleteCity(int id) async {
    try {
      var country = await _cityProvider.delete(id);
      if (country == "OK") {
        Navigator.of(context).pop();
        loadCities('');
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
          width: 1050,
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
                              title: const Text('Dodaj grad'),
                              content: SingleChildScrollView(
                                child: AddCityForm(),
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
                                      InsertCity();
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

  Widget AddCityForm({bool isEditing = false, City? cityToEdit}) {
    if (cityToEdit != null) {
      _nameController.text = cityToEdit.name;
      _zipCodeController.text = cityToEdit.zipCode;
      _selectedCountryId = cityToEdit.countryId;
      _isActiveNotifier.value = cityToEdit.isActive;
    } else {
      _nameController.text = '';
      _zipCodeController.text = '';
      _selectedCountryId = null;
      _cityIsActive = false;
    }

    return SizedBox(
      height: 300,
      width: 350,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Odaberite državu'),
              value: _selectedCountryId,
              items: countries.map<DropdownMenuItem<int>>((Country country) {
                return DropdownMenuItem<int>(
                  value: country.id,
                  child: Text(country.name),
                );
              }).toList(),
              onChanged: (int? selectedCountryId) {
                setState(() {
                  _selectedCountryId = selectedCountryId;
                });
              },
              validator: (int? value) {
                if (value == null) {
                  return 'Odaberite državu!';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Naziv grada'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Unesite naziv grada!';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _zipCodeController,
              decoration: const InputDecoration(labelText: 'ZipCode'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Unesite ZipCode!';
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
                        _cityIsActive = _isActiveNotifier.value;
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
                    "ZipCode",
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
                  flex: 4,
                  child: Text(
                    "Country",
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
              rows: cities
                  .map((City e) => DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(e.name.toString())),
                        DataCell(Text(e.zipCode.toString())),
                        DataCell(Text(e.isActive.toString())),
                        DataCell(Text(e.country.abbreviation.toString())),
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
                                        ? 'Uredi grad'
                                        : 'Dodaj grad'),
                                    content: SingleChildScrollView(
                                      child: AddCityForm(
                                          isEditing: isEditing, cityToEdit: e),
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
                                            EditCity(e.id);
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
                                    title: const Text("Izbrisi grad"),
                                    content: const SingleChildScrollView(
                                        child: Text(
                                            "Da li ste sigurni da zelite obisati grad?")),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Zatvorite modal
                                        },
                                        child: const Text('Odustani'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          DeleteCity(e.id);
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

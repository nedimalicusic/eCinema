// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:ecinema_admin/models/production.dart';
import 'package:ecinema_admin/providers/production_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/country.dart';
import '../../providers/country_provider.dart';
import '../../utils/error_dialog.dart';

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({Key? key}) : super(key: key);

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  List<Production> productions = <Production>[];
  List<Country> countries = <Country>[];
  late CountryProvider _countryProvider;
  late ProductionProvider _productionProvider;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  int? _selectedCountryId;
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _productionProvider = context.read<ProductionProvider>();
    _countryProvider = context.read<CountryProvider>();
    loadProductions('');
    loadCountries();
    _searchController.addListener(() {
      final searchQuery = _searchController.text;
      loadProductions(searchQuery);
    });
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

  void loadProductions(String? query) async {
    var params;
    try {
      if (query != null) {
        params = query;
      } else {
        params = null;
      }
      var productionsResponse =
          await _productionProvider.get({'params': params});
      setState(() {
        productions = productionsResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void InsertProduction() async {
    try {
      var newProduction = {
        "name": _nameController.text,
        "countryId": _selectedCountryId,
      };
      var city = await _productionProvider.insert(newProduction);
      if (city == "OK") {
        Navigator.of(context).pop();
        loadProductions('');
        setState(() {
          _selectedCountryId = null;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void EditProduction(int id) async {
    try {
      var newProduction = {
        "id": id,
        "name": _nameController.text,
        "countryId": _selectedCountryId,
      };
      var city = await _productionProvider.edit(newProduction);
      if (city == "OK") {
        Navigator.of(context).pop();
        loadProductions('');
        setState(() {
          _selectedCountryId = null;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void DeleteProduction(int id) async {
    try {
      var country = await _productionProvider.delete(id);
      if (country == "OK") {
        Navigator.of(context).pop();
        loadProductions('');
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
          width: 900,
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
                              title: const Text('Dodaj državu'),
                              content: SingleChildScrollView(
                                child: AddProductionForm(),
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
                                      InsertProduction();
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

  Widget AddProductionForm(
      {bool isEditing = false, Production? productionToEdit}) {
    if (productionToEdit != null) {
      _nameController.text = productionToEdit.name ?? '';
      _selectedCountryId = productionToEdit.countryId;
    } else {
      _nameController.text = '';
      _selectedCountryId = null;
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
              decoration: const InputDecoration(labelText: 'Naziv produkcije'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Unesite naziv produkcije';
                }
                return null;
              },
            ),
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
              rows: productions
                      .map((Production e) => DataRow(cells: [
                            DataCell(Text(e.id?.toString() ?? "")),
                            DataCell(Text(e.name?.toString() ?? "")),
                            DataCell(Text(e.country.name?.toString() ?? "")),
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
                                            ? 'Uredi produkciju'
                                            : 'Dodaj produkciju'),
                                        content: SingleChildScrollView(
                                          child: AddProductionForm(
                                              isEditing: isEditing,
                                              productionToEdit: e),
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
                                                EditProduction(e.id);
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
                                        title: const Text("Izbrisi produkciju"),
                                        content: const SingleChildScrollView(
                                            child: Text(
                                                "Da li ste sigurni da zelite obisati produkciju?")),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Odustani'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              DeleteProduction(e.id);
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
                      .toList() ??
                  [])),
    );
  }
}

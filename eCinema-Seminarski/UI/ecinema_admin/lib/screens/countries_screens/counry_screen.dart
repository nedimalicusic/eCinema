// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:ecinema_admin/models/country.dart';
import 'package:ecinema_admin/models/searchObject/country_search.dart';
import 'package:ecinema_admin/providers/country_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../helpers/constants.dart';
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
  List<Country> selectedCountry = <Country>[];
  int currentPage = 1;
  int pageSize = 5;
  int hasNextPage = 0;
  bool isAllSelected = false;

  @override
  void initState() {
    super.initState();
    _countryProvider = context.read<CountryProvider>();
    _isActiveNotifier = ValueNotifier<bool>(_countryIsActive);
    loadCountries(CountrySearchObject(
        name: _searchController.text,
        pageSize: pageSize,
        pageNumber: currentPage));

    _searchController.addListener(() {
      final searchQuery = _searchController.text;
      loadCountries(CountrySearchObject(
          name: searchQuery, pageNumber: currentPage, pageSize: pageSize));
    });
  }

  void loadCountries(CountrySearchObject searchObject) async {
    try {
      var countriesResponse =
          await _countryProvider.getPaged(searchObject: searchObject);
      setState(() {
        countries = countriesResponse;
        hasNextPage = countries.length;
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
        loadCountries(
          CountrySearchObject(
            name: _searchController.text,
            pageNumber: currentPage,
            pageSize: pageSize,
          ),
        );
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void DeleteCounty(int id) async {
    try {
      var country = await _countryProvider.delete(id);
      if (country == "OK") {
        loadCountries(
          CountrySearchObject(
            name: _searchController.text,
            pageNumber: currentPage,
            pageSize: pageSize,
          ),
        );
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
        loadCountries(
          CountrySearchObject(
            name: _searchController.text,
            pageNumber: currentPage,
            pageSize: pageSize,
          ),
        );
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Države"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    title: const Text("Dodaj državu"),
                    content: SingleChildScrollView(
                      child: AddCountryForm(),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          onPressed: () {
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
                              InsertCountry();
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
            if (selectedCountry.isEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Upozorenje"),
                      content: const Text(
                          "Morate odabrati barem jednu državu za uređivanje"),
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
            } else if (selectedCountry.length > 1) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Upozorenje"),
                      content: const Text(
                          "Odaberite samo jednu državu koji želite urediti"),
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
                      title: const Text("Uredi državu"),
                      content: AddCountryForm(
                          isEditing: true, countryToEdit: selectedCountry[0]),
                      actions: <Widget>[
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Zatvori",
                                style: TextStyle(color: white))),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor),
                            onPressed: () {
                              EditCountry(selectedCountry[0].id);
                              setState(() {
                                selectedCountry = [];
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
          onPressed: selectedCountry.isEmpty
              ? () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: const Text("Upozorenje"),
                            content: const Text(
                                "Morate odabrati državu koju želite obrisati."),
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
                          title: const Text("Izbriši državu!"),
                          content: const SingleChildScrollView(
                            child: Text(
                                "Da li ste sigurni da želite obrisati državu?"),
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
                                for (Country n in selectedCountry) {
                                  DeleteCounty(n.id);
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
                dataRowHeight: 50,
                dataRowColor: MaterialStateProperty.all(
                    const Color.fromARGB(42, 241, 241, 241)),
                columns: [
                  DataColumn(
                      label: Checkbox(
                          value: isAllSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              isAllSelected = value ?? false;
                              for (var countryItem in countries) {
                                countryItem.isSelected = isAllSelected;
                              }
                              if (!isAllSelected) {
                                selectedCountry.clear();
                              } else {
                                selectedCountry = List.from(countries);
                              }
                            });
                          })),
                  const DataColumn(
                    label: Expanded(child: Text('Naziv')),
                  ),
                  const DataColumn(
                    label: Expanded(child: Text('Skraćenica')),
                  ),
                  const DataColumn(
                    label: Expanded(child: Text('Aktivna')),
                  ),
                ],
                rows: countries
                    .map((Country countryItem) => DataRow(cells: [
                          DataCell(
                            Checkbox(
                              value: countryItem.isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  countryItem.isSelected = value ?? false;
                                  if (countryItem.isSelected == true) {
                                    selectedCountry.add(countryItem);
                                  } else {
                                    selectedCountry.remove(countryItem);
                                  }
                                  isAllSelected =
                                      countries.every((u) => u.isSelected);
                                });
                              },
                            ),
                          ),
                          DataCell(Text(countryItem.name.toString())),
                          DataCell(Text(countryItem.abbreviation.toString())),
                          DataCell(Text(countryItem.isActive.toString())),
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
              loadCountries(CountrySearchObject(
                pageNumber: currentPage,
                pageSize: pageSize,
              ));
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
              loadCountries(
                CountrySearchObject(
                    pageNumber: currentPage,
                    pageSize: pageSize,
                    name: _searchController.text),
              );
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

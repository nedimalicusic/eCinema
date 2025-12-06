// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:ecinema_admin/models/city.dart';
import 'package:ecinema_admin/models/country.dart';
import 'package:ecinema_admin/models/searchObject/city_search.dart';
import 'package:ecinema_admin/providers/city_provider.dart';
import 'package:ecinema_admin/providers/country_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../helpers/constants.dart';
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
  List<City> selectedCity = <City>[];
  int currentPage = 1;
  int pageSize = 5;
  int hasNextPage = 0;
  bool isAllSelected = false;

  @override
  void initState() {
    super.initState();
    _cityProvider = context.read<CityProvider>();
    _countryProvider = context.read<CountryProvider>();
    _isActiveNotifier = ValueNotifier<bool>(_cityIsActive);
    loadCountries();
    loadCities(CitySearchObject(name: _searchController.text, pageSize: pageSize, pageNumber: currentPage));

    _searchController.addListener(() {
      final searchQuery = _searchController.text;
      loadCities(CitySearchObject(name: searchQuery, pageNumber: currentPage, pageSize: pageSize));
    });
  }

  void loadCities(CitySearchObject searchObject) async {
    try {
      var citiesResponse = await _cityProvider.getPaged(searchObject: searchObject);
      setState(() {
        cities = citiesResponse;
        hasNextPage = cities.length;
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
      var newCity = {"name": _nameController.text, "zipCode": _zipCodeController.text, "countryId": _selectedCountryId, "isActive": _cityIsActive};
      var city = await _cityProvider.insert(newCity);
      if (city == "OK") {
        Navigator.of(context).pop();
        loadCities(
          CitySearchObject(
            name: _searchController.text,
            pageNumber: currentPage,
            pageSize: pageSize,
          ),
        );
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
      var newCity = {"id": id, "name": _nameController.text, "zipCode": _zipCodeController.text, "countryId": _selectedCountryId, "isActive": _cityIsActive};
      var city = await _cityProvider.edit(newCity);
      if (city == "OK") {
        Navigator.of(context).pop();
        loadCities(
          CitySearchObject(
            name: _searchController.text,
            pageNumber: currentPage,
            pageSize: pageSize,
          ),
        );
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
        loadCities(
          CitySearchObject(
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

  Row BuildSearchField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
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
                      margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
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
        ),
        const SizedBox(
          width: 20,
        ),
        buildButtons(context),
      ],
    );
  }

  Expanded buildButtons(BuildContext context) {
    return Expanded(
      child: Row(
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
                      title: const Text("Dodaj grad"),
                      content: SingleChildScrollView(
                        child: AddCityForm(),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Zatvori", style: TextStyle(color: white))),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                InsertCity();
                              }
                            },
                            child: const Text("Spremi", style: TextStyle(color: white)))
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
              if (selectedCity.isEmpty) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Upozorenje"),
                        content: const Text("Morate odabrati barem jedan grad za uređivanje"),
                        actions: <Widget>[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK", style: TextStyle(color: white)),
                          ),
                        ],
                      );
                    });
              } else if (selectedCity.length > 1) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Upozorenje"),
                        content: const Text("Odaberite samo jedan grad koji želite urediti"),
                        actions: <Widget>[
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Ok", style: TextStyle(color: white)))
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
                        content: AddCityForm(isEditing: true, cityToEdit: selectedCity[0]),
                        actions: <Widget>[
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Zatvori", style: TextStyle(color: white))),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  EditCity(selectedCity[0].id);
                                  setState(() {
                                    selectedCity = [];
                                  });
                                }
                              },
                              child: const Text("Spremi", style: TextStyle(color: white))),
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
            onPressed: selectedCity.isEmpty
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(title: const Text("Upozorenje"), content: const Text("Morate odabrati grad koji želite obrisati."), actions: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK", style: TextStyle(color: white)),
                            ),
                          ]);
                        });
                  }
                : () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Izbriši grad!"),
                            content: const SingleChildScrollView(
                              child: Text("Da li ste sigurni da želite obrisati grad?"),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Odustani", style: TextStyle(color: white)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  for (City n in selectedCity) {
                                    DeleteCity(n.id);
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Obriši", style: TextStyle(color: white)),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Gradovi"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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

  Expanded buildDataList(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.teal, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DataTable(
                dataRowHeight: 50,
                dataRowColor: MaterialStateProperty.all(const Color.fromARGB(42, 241, 241, 241)),
                columns: [
                  DataColumn(
                      label: Checkbox(
                          value: isAllSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              isAllSelected = value ?? false;
                              for (var cityItem in cities) {
                                cityItem.isSelected = isAllSelected;
                              }
                              if (!isAllSelected) {
                                selectedCity.clear();
                              } else {
                                selectedCity = List.from(cities);
                              }
                            });
                          })),
                  const DataColumn(
                    label: Expanded(child: Text('Naziv')),
                  ),
                  const DataColumn(
                    label: Expanded(child: Text('Zip')),
                  ),
                  const DataColumn(
                    label: Expanded(child: Text('Aktivn')),
                  ),
                  const DataColumn(
                    label: Expanded(child: Text('Država')),
                  ),
                ],
                rows: cities
                    .map((City cityItem) => DataRow(cells: [
                          DataCell(
                            Checkbox(
                              value: cityItem.isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  cityItem.isSelected = value ?? false;
                                  if (cityItem.isSelected == true) {
                                    selectedCity.add(cityItem);
                                  } else {
                                    selectedCity.remove(cityItem);
                                  }
                                  isAllSelected = countries.every((u) => u.isSelected);
                                });
                              },
                            ),
                          ),
                          DataCell(Text(cityItem.name.toString())),
                          DataCell(Text(cityItem.zipCode.toString())),
                          DataCell(Text(cityItem.isActive.toString())),
                          DataCell(Text(cityItem.country.name.toString())),
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
              loadCities(CitySearchObject(
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
              loadCities(
                CitySearchObject(pageNumber: currentPage, pageSize: pageSize, name: _searchController.text),
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

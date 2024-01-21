// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:ecinema_admin/models/production.dart';
import 'package:ecinema_admin/models/searchObject/production_search.dart';
import 'package:ecinema_admin/providers/production_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../helpers/constants.dart';
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
  List<Production> selectedProduction = <Production>[];
  int? _selectedCountryId;
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  int currentPage = 1;
  int pageSize = 5;
  int hasNextPage = 0;
  bool isAllSelected = false;

  @override
  void initState() {
    super.initState();
    _productionProvider = context.read<ProductionProvider>();
    _countryProvider = context.read<CountryProvider>();
    loadCountries();
    loadProductions(ProductionSearchObject(
        name: _searchController.text,
        pageSize: pageSize,
        pageNumber: currentPage));

    _searchController.addListener(() {
      final searchQuery = _searchController.text;
      loadProductions(ProductionSearchObject(
          name: searchQuery, pageNumber: currentPage, pageSize: pageSize));
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

  void loadProductions(ProductionSearchObject searchObject) async {
    try {
      var moviesResponse =
          await _productionProvider.getPaged(searchObject: searchObject);
      setState(() {
        productions = moviesResponse;
        hasNextPage = productions.length;
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
        loadProductions(
          ProductionSearchObject(
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
        loadProductions(
          ProductionSearchObject(
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

  void DeleteProduction(int id) async {
    try {
      var country = await _productionProvider.delete(id);
      if (country == "OK") {
        loadProductions(
          ProductionSearchObject(
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
          title: const Text("Produkcije"),
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
                    title: const Text("Dodaj produkciju"),
                    content: SingleChildScrollView(
                      child: AddProductionForm(),
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
                              InsertProduction();
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
            if (selectedProduction.isEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Upozorenje"),
                      content: const Text(
                          "Morate odabrati barem jednu produkciju za uređivanje"),
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
            } else if (selectedProduction.length > 1) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Upozorenje"),
                      content: const Text(
                          "Odaberite samo jednu projekciju koju želite urediti"),
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
                      title: const Text("Uredi projekciju"),
                      content: AddProductionForm(
                          isEditing: true,
                          productionToEdit: selectedProduction[0]),
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
                              EditProduction(selectedProduction[0].id);
                              setState(() {
                                selectedProduction = [];
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
          onPressed: selectedProduction.isEmpty
              ? () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: const Text("Upozorenje"),
                            content: const Text(
                                "Morate odabrati projekciju koju želite obrisati."),
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
                          title: const Text("Izbriši projekciju!"),
                          content: const SingleChildScrollView(
                            child: Text(
                                "Da li ste sigurni da želite obrisati projekciju?"),
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
                                for (Production n in selectedProduction) {
                                  DeleteProduction(n.id);
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

  Widget AddProductionForm(
      {bool isEditing = false, Production? productionToEdit}) {
    if (productionToEdit != null) {
      _nameController.text = productionToEdit.name;
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
                              for (var productionItem in productions) {
                                productionItem.isSelected = isAllSelected;
                              }
                              if (!isAllSelected) {
                                selectedProduction.clear();
                              } else {
                                selectedProduction = List.from(productions);
                              }
                            });
                          })),
                  const DataColumn(
                    label: Expanded(child: Text('Naziv')),
                  ),
                  const DataColumn(
                    label: Text('Država'),
                  ),
                ],
                rows: productions
                    .map((Production productionItem) => DataRow(cells: [
                          DataCell(
                            Checkbox(
                              value: productionItem.isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  productionItem.isSelected = value ?? false;
                                  if (productionItem.isSelected == true) {
                                    selectedProduction.add(productionItem);
                                  } else {
                                    selectedProduction.remove(productionItem);
                                  }
                                  isAllSelected =
                                      productions.every((u) => u.isSelected);
                                });
                              },
                            ),
                          ),
                          DataCell(Text(productionItem.name.toString())),
                          DataCell(
                              Text(productionItem.country.name.toString())),
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
              loadProductions(ProductionSearchObject(
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
              loadProductions(
                ProductionSearchObject(
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

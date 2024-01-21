// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:ecinema_admin/models/language.dart';
import 'package:ecinema_admin/models/searchObject/language_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../helpers/constants.dart';
import '../../providers/language_provider.dart';
import '../../utils/error_dialog.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  List<Language> languages = <Language>[];
  late LanguageProvider _languageProvider;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool isEditing = false;
  List<Language> selectedLanguage = <Language>[];
  int currentPage = 1;
  int pageSize = 5;
  int hasNextPage = 0;
  bool isAllSelected = false;

  @override
  void initState() {
    super.initState();
    _languageProvider = context.read<LanguageProvider>();
    loadLanguages(LanguageSearchObject(
        name: _searchController.text,
        pageSize: pageSize,
        pageNumber: currentPage));

    _searchController.addListener(() {
      final searchQuery = _searchController.text;
      loadLanguages(LanguageSearchObject(
          name: searchQuery, pageNumber: currentPage, pageSize: pageSize));
    });
  }

  void loadLanguages(LanguageSearchObject searchObject) async {
    try {
      var languageResponse =
          await _languageProvider.getPaged(searchObject: searchObject);
      setState(() {
        languages = languageResponse;
        hasNextPage = languages.length;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void InsertLanguage() async {
    try {
      var newLanguage = {
        "name": _nameController.text,
      };
      var language = await _languageProvider.insert(newLanguage);
      if (language == "OK") {
        Navigator.of(context).pop();
        loadLanguages(
          LanguageSearchObject(
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

  void DeleteLanguage(int id) async {
    try {
      var country = await _languageProvider.delete(id);
      if (country == "OK") {
        loadLanguages(
          LanguageSearchObject(
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

  void EditLanguage(int id) async {
    try {
      var newLanguage = {
        "id": id,
        "name": _nameController.text,
      };
      var language = await _languageProvider.edit(newLanguage);
      if (language == "OK") {
        Navigator.of(context).pop();
        loadLanguages(
          LanguageSearchObject(
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
          title: const Text("Jezici"),
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
                    title: const Text("Dodaj jezik"),
                    content: SingleChildScrollView(
                      child: AddLanguageForm(),
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
                              InsertLanguage();
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
            if (selectedLanguage.isEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Upozorenje"),
                      content: const Text(
                          "Morate odabrati barem jedan jezik za uređivanje"),
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
            } else if (selectedLanguage.length > 1) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Upozorenje"),
                      content: const Text(
                          "Odaberite samo jedan jezik koji želite urediti"),
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
                      content: AddLanguageForm(
                          isEditing: true, languageToEdit: selectedLanguage[0]),
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
                              EditLanguage(selectedLanguage[0].id);
                              setState(() {
                                selectedLanguage = [];
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
          onPressed: selectedLanguage.isEmpty
              ? () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: const Text("Upozorenje"),
                            content: const Text(
                                "Morate odabrati jezik koji želite obrisati."),
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
                          title: const Text("Izbriši jezik!"),
                          content: const SingleChildScrollView(
                            child: Text(
                                "Da li ste sigurni da želite obrisati jezik?"),
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
                                for (Language n in selectedLanguage) {
                                  DeleteLanguage(n.id);
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

  Widget AddLanguageForm({bool isEditing = false, Language? languageToEdit}) {
    if (languageToEdit != null) {
      _nameController.text = languageToEdit.name;
    } else {
      _nameController.text = '';
    }

    return SizedBox(
      height: 100,
      width: 300,
      child: (Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Naziv jezika'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Unesite naziv jezika';
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
                              for (var langaugeItem in languages) {
                                langaugeItem.isSelected = isAllSelected;
                              }
                              if (!isAllSelected) {
                                selectedLanguage.clear();
                              } else {
                                selectedLanguage = List.from(languages);
                              }
                            });
                          })),
                  const DataColumn(
                    label: Expanded(child: Text('Naziv')),
                  ),
                ],
                rows: languages
                    .map((Language languageItem) => DataRow(cells: [
                          DataCell(
                            Checkbox(
                              value: languageItem.isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  languageItem.isSelected = value ?? false;
                                  if (languageItem.isSelected == true) {
                                    selectedLanguage.add(languageItem);
                                  } else {
                                    selectedLanguage.remove(languageItem);
                                  }
                                  isAllSelected =
                                      languages.every((u) => u.isSelected);
                                });
                              },
                            ),
                          ),
                          DataCell(Text(languageItem.name.toString())),
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
              loadLanguages(LanguageSearchObject(
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
              loadLanguages(
                LanguageSearchObject(
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

// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:ecinema_admin/models/language.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  @override
  void initState() {
    super.initState();
    _languageProvider = context.read<LanguageProvider>();
    loadLanguages('');
    _searchController.addListener(() {
      final searchQuery = _searchController.text;
      loadLanguages(searchQuery);
    });
  }

  void loadLanguages(String? query) async {
    var params;
    try {
      if (query != null) {
        params = query;
      } else {
        params = null;
      }
      var languagesResponse = await _languageProvider.get({'params': params});
      setState(() {
        languages = languagesResponse;
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
        loadLanguages('');
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void DeleteLanguage(int id) async {
    try {
      var country = await _languageProvider.delete(id);
      if (country == "OK") {
        Navigator.of(context).pop();
        loadLanguages('');
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
        loadLanguages('');
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
          width: 670,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 380,
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
                              title: const Text('Dodaj jezik'),
                              content: SingleChildScrollView(
                                child: AddLanguageForm(),
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
                                      InsertLanguage();
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

  Widget AddLanguageForm({bool isEditing = false, Language? languageToEdit}) {
    if (languageToEdit != null) {
      _nameController.text = languageToEdit.name ?? '';
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
              rows: languages
                      .map((Language e) => DataRow(cells: [
                            DataCell(Text(e.id?.toString() ?? "")),
                            DataCell(Text(e.name?.toString() ?? "")),
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
                                            ? 'Uredi jezik'
                                            : 'Dodaj jezik'),
                                        content: SingleChildScrollView(
                                          child: AddLanguageForm(
                                              isEditing: isEditing,
                                              languageToEdit: e),
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
                                                EditLanguage(e.id);
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
                                        title: const Text("Izbrisi jezik"),
                                        content: const SingleChildScrollView(
                                            child: Text(
                                                "Da li ste sigurni da zelite obisati jezik?")),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Odustani'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              DeleteLanguage(e.id);
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

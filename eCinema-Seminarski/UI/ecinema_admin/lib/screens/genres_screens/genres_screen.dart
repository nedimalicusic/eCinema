// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:ecinema_admin/models/genre.dart';
import 'package:ecinema_admin/providers/genre_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/error_dialog.dart';

class GenresScreen extends StatefulWidget {
  const GenresScreen({Key? key}) : super(key: key);

  @override
  State<GenresScreen> createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  List<Genre> genres = <Genre>[];
  late GenreProvider _genreProvider;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  bool isEditing = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _genreProvider = context.read<GenreProvider>();
    loadGenres('');
    _searchController.addListener(() {
      final searchQuery = _searchController.text;
      loadGenres(searchQuery);
    });
  }

  void loadGenres(String? query) async {
    var params;
    try {
      if (query != null) {
        params = query;
      } else {
        params = null;
      }
      var genresResponse = await _genreProvider.get({'params': params});
      setState(() {
        genres = genresResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void InsertGenre() async {
    try {
      var newGenre = {
        "name": _nameController.text,
      };
      var language = await _genreProvider.insert(newGenre);
      if (language == "OK") {
        Navigator.of(context).pop();
        loadGenres('');
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void DeleteGenre(int id) async {
    try {
      var genre = await _genreProvider.delete(id);
      if (genre == "OK") {
        Navigator.of(context).pop();
        loadGenres('');
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void EditGenre(int id) async {
    try {
      var newGenre = {
        "id": id,
        "name": _nameController.text,
      };
      var language = await _genreProvider.edit(newGenre);
      if (language == "OK") {
        Navigator.of(context).pop();
        loadGenres('');
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
          width: 700,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 400,
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
                        // Dodajte logiku za pretragu ovde
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, right: 146), // Margine za dugme "Dodaj"
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Dodaj žanr'),
                              content: SingleChildScrollView(
                                child: AddGenreForm(),
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
                                      InsertGenre();
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

  Widget AddGenreForm({bool isEditing = false, Genre? genreToEdit}) {
    if (genreToEdit != null) {
      _nameController.text = genreToEdit.name;
    } else {
      _nameController.text = '';
    }

    return SizedBox(
      height: 150,
      width: 300,
      child: (Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Naziv žanra'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Unesite naziv žanra!';
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
              rows: genres
                  .map((Genre e) => DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(e.name.toString())),
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
                                        ? 'Uredi žanr'
                                        : 'Dodaj žanr'),
                                    content: SingleChildScrollView(
                                      child: AddGenreForm(
                                          isEditing: isEditing, genreToEdit: e),
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
                                            EditGenre(e.id);
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
                                    title: const Text("Izbrisi žanr"),
                                    content: const SingleChildScrollView(
                                        child: Text(
                                            "Da li ste sigurni da zelite obisati žanr?")),
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
                                          DeleteGenre(e.id);
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

// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:ecinema_admin/models/genre.dart';
import 'package:ecinema_admin/models/searchObject/genre_search.dart';
import 'package:ecinema_admin/providers/genre_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../helpers/constants.dart';
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
  final TextEditingController _searchController = TextEditingController();
  bool isEditing = false;
  List<Genre> selectedGenre = <Genre>[];
  int currentPage = 1;
  int pageSize = 5;
  int hasNextPage = 0;
  bool isAllSelected = false;
  @override
  void initState() {
    super.initState();
    _genreProvider = context.read<GenreProvider>();
    loadGenres(GenreSearchObject(
        name: _searchController.text,
        pageSize: pageSize,
        pageNumber: currentPage));

    _searchController.addListener(() {
      final searchQuery = _searchController.text;
      loadGenres(GenreSearchObject(
          name: searchQuery, pageNumber: currentPage, pageSize: pageSize));
    });
  }

  void loadGenres(GenreSearchObject searchObject) async {
    try {
      var genreResponse =
          await _genreProvider.getPaged(searchObject: searchObject);
      setState(() {
        genres = genreResponse;
        hasNextPage = genres.length;
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
        loadGenres(
          GenreSearchObject(
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

  void DeleteGenre(int id) async {
    try {
      var genre = await _genreProvider.delete(id);
      if (genre == "OK") {
        loadGenres(
          GenreSearchObject(
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

  void EditGenre(int id) async {
    try {
      var newGenre = {
        "id": id,
        "name": _nameController.text,
      };
      var language = await _genreProvider.edit(newGenre);
      if (language == "OK") {
        Navigator.of(context).pop();
        loadGenres(
          GenreSearchObject(
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
          title: const Text("Žanrovi"),
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
                    title: const Text("Dodaj žanr"),
                    content: SingleChildScrollView(
                      child: AddGenreForm(),
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
                              InsertGenre();
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
            if (selectedGenre.isEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Upozorenje"),
                      content: const Text(
                          "Morate odabrati barem jedan žanr za uređivanje"),
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
            } else if (selectedGenre.length > 1) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Upozorenje"),
                      content: const Text(
                          "Odaberite samo jedan žanr koji želite urediti"),
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
                      content: AddGenreForm(
                          isEditing: true, genreToEdit: selectedGenre[0]),
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
                              EditGenre(selectedGenre[0].id);
                              setState(() {
                                selectedGenre = [];
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
          onPressed: selectedGenre.isEmpty
              ? () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: const Text("Upozorenje"),
                            content: const Text(
                                "Morate odabrati žanr koji želite obrisati."),
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
                          title: const Text("Izbriši žanr!"),
                          content: const SingleChildScrollView(
                            child: Text(
                                "Da li ste sigurni da želite obrisati žanr?"),
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
                                for (Genre n in selectedGenre) {
                                  DeleteGenre(n.id);
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
                              for (var ganreItem in genres) {
                                ganreItem.isSelected = isAllSelected;
                              }
                              if (!isAllSelected) {
                                selectedGenre.clear();
                              } else {
                                selectedGenre = List.from(genres);
                              }
                            });
                          })),
                  const DataColumn(
                    label: Expanded(child: Text('Naziv')),
                  ),
                ],
                rows: genres
                    .map((Genre genreItem) => DataRow(cells: [
                          DataCell(
                            Checkbox(
                              value: genreItem.isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  genreItem.isSelected = value ?? false;
                                  if (genreItem.isSelected == true) {
                                    selectedGenre.add(genreItem);
                                  } else {
                                    selectedGenre.remove(genreItem);
                                  }
                                  isAllSelected =
                                      genres.every((u) => u.isSelected);
                                });
                              },
                            ),
                          ),
                          DataCell(Text(genreItem.name.toString())),
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
              loadGenres(GenreSearchObject(
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
              loadGenres(
                GenreSearchObject(
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

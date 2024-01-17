// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:ecinema_admin/models/actor.dart';
import 'package:ecinema_admin/models/language.dart';
import 'package:ecinema_admin/models/movie.dart';
import 'package:ecinema_admin/models/production.dart';
import 'package:ecinema_admin/providers/actor_provider.dart';
import 'package:ecinema_admin/providers/genre_provider.dart';
import 'package:ecinema_admin/providers/language_provider.dart';
import 'package:ecinema_admin/providers/movie_provider.dart';
import 'package:ecinema_admin/providers/production_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;
import '../../models/genre.dart';
import '../../providers/photo_provider.dart';
import '../../utils/authorzation.dart';
import '../../utils/error_dialog.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({Key? key}) : super(key: key);

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  List<Movie> movies = <Movie>[];
  List<Genre> genres = <Genre>[];
  List<Language> languages = <Language>[];
  List<Production> productions = <Production>[];
  List<Actor> actors = <Actor>[];
  late MovieProvider _movieProvider;
  late GenreProvider _genreProvider;
  late LanguageProvider _languageProvider;
  late ProductionProvider _productionProvider;
  late ActorProvider _actorProvider;
  late PhotoProvider _photoProvider;
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _relaseYearController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  ValueNotifier<File?> _pickedFileNotifier = ValueNotifier(null);
  int? selectedLanguageId;
  int? selectedProductionId;
  int? selectedgenreId;
  File? _pickedFile;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _movieProvider = context.read<MovieProvider>();
    _photoProvider = context.read<PhotoProvider>();
    _genreProvider = context.read<GenreProvider>();
    _languageProvider = context.read<LanguageProvider>();
    _productionProvider = context.read<ProductionProvider>();
    _actorProvider = context.read<ActorProvider>();
    _pickedFileNotifier = ValueNotifier<File?>(_pickedFile);
    loadMovies('');
    loadGenres();
    loadLanguages();
    loadProductions();
    loadActors();
    _searchController.addListener(() {
      final searchQuery = _searchController.text;
      loadMovies(searchQuery);
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _pickedFileNotifier.value = File(pickedFile.path);
      _pickedFile = File(pickedFile.path);
    }
  }

  Future<String> loadPhoto(String guidId) async {
    return await _photoProvider.getPhoto(guidId);
  }

  void loadMovies(String? query) async {
    var params;
    try {
      if (query != null) {
        params = query;
      } else {
        params = null;
      }
      var moviesResponse = await _movieProvider.get({'params': params});
      setState(() {
        movies = moviesResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadGenres() async {
    try {
      var genresResponse = await _genreProvider.get(null);
      setState(() {
        genres = genresResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadLanguages() async {
    try {
      var languagesResponse = await _languageProvider.get(null);
      setState(() {
        languages = languagesResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadActors() async {
    try {
      var actorsResponse = await _actorProvider.get(null);
      setState(() {
        actors = actorsResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadProductions() async {
    try {
      var productionResponse = await _productionProvider.get(null);
      setState(() {
        productions = productionResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void insertMovie() async {
    try {
      Map<String, dynamic> movieData = {
        'Title': _titleController.text,
        'Description': _descriptionController.text,
        'Author': _authorController.text,
        'ReleaseYear': _relaseYearController.text,
        'Duration': _durationController.text,
        'LanguageId': selectedLanguageId,
        'ProductionId': selectedProductionId,
      };
      if (_pickedFile != null) {
        movieData['photo'] = http.MultipartFile.fromBytes(
          'photo',
          _pickedFile!.readAsBytesSync(),
          filename: 'photo.jpg',
        );
      }
      var response = await _movieProvider.insertMovie(movieData);

      if (response == "OK") {
        Navigator.of(context).pop();
        loadMovies('');
      } else {
        showErrorDialog(context, 'Greška prilikom uređivanja');
      }
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  void editMovie(int id) async {
    try {
      Map<String, dynamic> movieData = {
        "Id": id.toString(),
        'Title': _titleController.text,
        'Description': _descriptionController.text,
        'Author': _authorController.text,
        'ReleaseYear': _relaseYearController.text,
        'Duration': _durationController.text,
        'LanguageId': selectedLanguageId,
        'ProductionId': selectedProductionId,
      };
      if (_pickedFile != null) {
        movieData['Photo'] = http.MultipartFile.fromBytes(
          'Photo',
          _pickedFile!.readAsBytesSync(),
          filename: 'photo.jpg',
        );
      }
      var response = await _movieProvider.updateMovie(movieData);

      if (response == "OK") {
        Navigator.of(context).pop();
        loadMovies('');
      } else {
        showErrorDialog(context, 'Greška prilikom uređivanja');
      }
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  void DeleteMovie(int id) async {
    try {
      var user = await _movieProvider.delete(id);
      if (user == "OK") {
        Navigator.of(context).pop();
        loadMovies('');
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
          width: 1500,
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
                              title: const Text('Dodaj film'),
                              content: SingleChildScrollView(
                                child: AddMovieForm(),
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
                                      insertMovie();
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

  Widget AddMovieForm({bool isEditing = false, Movie? movieToEdit}) {
    if (movieToEdit != null) {
      _titleController.text = movieToEdit.title;
      _descriptionController.text = movieToEdit.description;
      _authorController.text = movieToEdit.author;
      _relaseYearController.text = movieToEdit.releaseYear.toString();
      _durationController.text = movieToEdit.duration.toString();
      _pickedFile = null;
    } else {
      _titleController.text = '';
      _descriptionController.text = '';
      _authorController.text = '';
      _relaseYearController.text = '';
      _durationController.text = '';
      _pickedFile = null;
    }

    return SizedBox(
      height: 500,
      width: 900,
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
                child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(35),
                child: Column(children: [
                  ValueListenableBuilder<File?>(
                      valueListenable: _pickedFileNotifier,
                      builder: (context, pickedFile, _) {
                        return Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 180,
                          color: Colors.teal,
                          child: FutureBuilder<String>(
                            future: _pickedFile != null
                                ? Future.value(_pickedFile!.path)
                                : loadPhoto(isEditing
                                    ? (movieToEdit?.photo?.guidId ?? '')
                                    : ''),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return const Text(
                                    'Molimo odaberite fotografiju');
                              } else {
                                final imageUrl = snapshot.data;

                                if (imageUrl != null && imageUrl.isNotEmpty) {
                                  return FadeInImage(
                                    image: _pickedFile != null
                                        ? FileImage(_pickedFile!)
                                        : NetworkImage(
                                            imageUrl,
                                            headers:
                                                Authorization.createHeaders(),
                                          ) as ImageProvider<Object>,
                                    placeholder: MemoryImage(kTransparentImage),
                                    fadeInDuration:
                                        const Duration(milliseconds: 300),
                                    fit: BoxFit.cover,
                                    width: 230,
                                    height: 200,
                                  );
                                } else {
                                  return isEditing
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: const Text(
                                              'Please select an image'),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Image.asset(
                                            'assets/images/default_user_image.jpg',
                                            width: 230,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                }
                              }
                            },
                          ),
                        );
                      }),
                  const SizedBox(height: 35),
                  Center(
                    child: SizedBox(
                      width: 150,
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () => _pickImage(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text('Select An Image',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                    ),
                  )
                ]),
              ),
            )),
            const SizedBox(
              width: 30,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Naziv'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Unesite naziv!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _relaseYearController,
                    decoration:
                        const InputDecoration(labelText: 'Godina izdavanja'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Unesite godinu izdavanja!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _authorController,
                    decoration: const InputDecoration(labelText: 'Autor'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Unesite autora!';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<int>(
                    value: selectedgenreId,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedgenreId = newValue;
                      });
                    },
                    items: genres.map((Genre genre) {
                      return DropdownMenuItem<int>(
                        value: genre.id,
                        child: Text(genre.name),
                      );
                    }).toList(),
                    decoration: const InputDecoration(labelText: 'Žanr'),
                    validator: (value) {
                      if (value == null) {
                        return 'Odaberite žanr!';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<int>(
                    value: selectedLanguageId,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedLanguageId = newValue;
                      });
                    },
                    items: languages.map((Language language) {
                      return DropdownMenuItem<int>(
                        value: language.id,
                        child: Text(language.name),
                      );
                    }).toList(),
                    decoration: const InputDecoration(labelText: 'Jezik'),
                    validator: (value) {
                      if (value == null) {
                        return 'Odaberite jezik!';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _durationController,
                    decoration: const InputDecoration(labelText: 'Trajanje'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Unesite trajanje!';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<int>(
                    value: selectedProductionId,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedProductionId = newValue;
                      });
                    },
                    items: productions.map((Production production) {
                      return DropdownMenuItem<int>(
                        value: production.id,
                        child: Text(production.name),
                      );
                    }).toList(),
                    decoration: const InputDecoration(labelText: 'Produkcija'),
                    validator: (value) {
                      if (value == null) {
                        return 'Odaberite produkciju!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Opis'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Unesite opis!';
                      }
                      return null;
                    },
                  ),
                ],
              ),
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
                    "Slika",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  flex: 5,
                  child: Text(
                    "Title",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  flex: 4,
                  child: Text(
                    "Author",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  flex: 2,
                  child: Text(
                    "ReleaseYear",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  flex: 2,
                  child: Text(
                    "Duration",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  flex: 2,
                  child: Text(
                    "Production",
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
              rows: movies
                  .map((Movie e) => DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FutureBuilder<String>(
                                  future: loadPhoto(e.photo?.guidId ?? ''),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return const Text(
                                          'Greška prilikom učitavanja slike');
                                    } else {
                                      final imageUrl = snapshot.data;

                                      if (imageUrl != null &&
                                          imageUrl.isNotEmpty) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: FadeInImage(
                                            image: NetworkImage(
                                              imageUrl,
                                              headers:
                                                  Authorization.createHeaders(),
                                            ),
                                            placeholder:
                                                MemoryImage(kTransparentImage),
                                            fadeInDuration: const Duration(
                                                milliseconds: 300),
                                            fit: BoxFit.fill,
                                            width: 50,
                                            height: 100,
                                          ),
                                        );
                                      } else {
                                        null;
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Image.asset(
                                            'assets/images/user1.jpg',
                                            width: 80,
                                            height: 105,
                                            fit: BoxFit.fill,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text(e.title.toString())),
                        DataCell(Text(e.author.toString())),
                        DataCell(Text(e.releaseYear.toString())),
                        DataCell(Text(e.duration.toString())),
                        DataCell(Text(e.production.name.toString())),
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
                                        ? 'Uredi film'
                                        : 'Dodaj film'),
                                    content: SingleChildScrollView(
                                      child: AddMovieForm(
                                          isEditing: isEditing, movieToEdit: e),
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
                                            editMovie(e.id);
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
                                    title: const Text("Izbrisi film"),
                                    content: const SingleChildScrollView(
                                        child: Text(
                                            "Da li ste sigurni da zelite obisati film?")),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Odustani'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          DeleteMovie(e.id);
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

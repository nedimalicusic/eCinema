// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:ecinema_admin/models/actor.dart';
import 'package:ecinema_admin/models/category.dart';
import 'package:ecinema_admin/models/language.dart';
import 'package:ecinema_admin/models/movie.dart';
import 'package:ecinema_admin/models/production.dart';
import 'package:ecinema_admin/models/searchObject/movie_search.dart';
import 'package:ecinema_admin/providers/actor_provider.dart';
import 'package:ecinema_admin/providers/category_provider.dart';
import 'package:ecinema_admin/providers/genre_provider.dart';
import 'package:ecinema_admin/providers/language_provider.dart';
import 'package:ecinema_admin/providers/movie_provider.dart';
import 'package:ecinema_admin/providers/production_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;
import '../../helpers/constants.dart';
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
  List<Category> categories = <Category>[];
  List<Language> languages = <Language>[];
  List<Production> productions = <Production>[];
  List<Actor> actors = <Actor>[];
  late MovieProvider _movieProvider;
  late GenreProvider _genreProvider;
  late CategoryProvider _categoryProvider;
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
  List<Movie> selectedMovie = <Movie>[];
  int? selectedLanguageId;
  int? selectedProductionId;
  var selectedCategoriesId = <int>[];
  var selectedGenresId = <int>[];
  var selectedActorsId = <int>[];
  File? _pickedFile;
  File? selectedImage;
  int currentPage = 1;
  int pageSize = 5;
  int hasNextPage = 0;
  bool isAllSelected = false;

  @override
  void initState() {
    super.initState();
    _movieProvider = context.read<MovieProvider>();
    _photoProvider = context.read<PhotoProvider>();
    _genreProvider = context.read<GenreProvider>();
    _categoryProvider = context.read<CategoryProvider>();
    _languageProvider = context.read<LanguageProvider>();
    _productionProvider = context.read<ProductionProvider>();
    _actorProvider = context.read<ActorProvider>();
    _pickedFileNotifier = ValueNotifier<File?>(_pickedFile);
    loadGenres();
    loadCategories();
    loadLanguages();
    loadProductions();
    loadActors();
    loadMovies(MovieSearchObject(
        name: _searchController.text,
        pageSize: pageSize,
        pageNumber: currentPage));

    _searchController.addListener(() {
      final searchQuery = _searchController.text;
      loadMovies(MovieSearchObject(
          name: searchQuery, pageNumber: currentPage, pageSize: pageSize));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pickedFileNotifier.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      setState(() {
        _pickedFile = file;
        _pickedFileNotifier.value = file;
      });
    }
  }

  Future<String> loadPhoto(String guidId) async {
    return await _photoProvider.getPhoto(guidId);
  }

  void loadMovies(MovieSearchObject searchObject) async {
    try {
      var moviesResponse =
          await _movieProvider.getPaged(searchObject: searchObject);
      if (mounted) {
        setState(() {
          movies = moviesResponse;
          hasNextPage = movies.length;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadCategories() async {
    try {
      var categoriesResponse = await _categoryProvider.get(null);
      if (mounted) {
        setState(() {
          categories = categoriesResponse;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadGenres() async {
    try {
      var genresResponse = await _genreProvider.get(null);
      if (mounted) {
        setState(() {
          genres = genresResponse;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadLanguages() async {
    try {
      var languagesResponse = await _languageProvider.get(null);
      if (mounted) {
        setState(() {
          languages = languagesResponse;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadActors() async {
    try {
      var actorsResponse = await _actorProvider.get(null);
      if (mounted) {
        setState(() {
          actors = actorsResponse;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadProductions() async {
    try {
      var productionResponse = await _productionProvider.get(null);
      if (mounted) {
        setState(() {
          productions = productionResponse;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void insertMovie() async {
    try {
      if (_pickedFile == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Alert'),
              content: const Text('Please select an image.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }
      Map<String, dynamic> movieData = {
        'Title': _titleController.text,
        'Description': _descriptionController.text,
        'Author': _authorController.text,
        'ReleaseYear': _relaseYearController.text,
        'Duration': _durationController.text,
        'LanguageId': selectedLanguageId,
        'ProductionId': selectedProductionId,
        'GenreIds': selectedGenresId.toList(),
        'ActorIds': selectedActorsId.toList(),
        'CategoryIds': selectedCategoriesId.toList(),
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
        loadMovies(
          MovieSearchObject(
            name: _searchController.text,
            pageNumber: currentPage,
            pageSize: pageSize,
          ),
        );
        selectedProductionId = null;
        selectedLanguageId = null;
        selectedGenresId = <int>[];
        selectedActorsId = <int>[];
        selectedCategoriesId = <int>[];
      } else {
        showErrorDialog(context, 'Greška prilikom dodavanja');
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
        'GenreIds': selectedGenresId.toList(),
        'ActorIds': selectedActorsId.toList(),
        'CategoryIds': selectedCategoriesId.toList(),
      };
      if (_pickedFile != null) {
        movieData['photo'] = http.MultipartFile.fromBytes(
          'photo',
          _pickedFile!.readAsBytesSync(),
          filename: 'photo.jpg',
        );
      }
      var response = await _movieProvider.updateMovie(movieData);

      if (response == "OK") {
        Navigator.of(context).pop();
        loadMovies(
          MovieSearchObject(
            name: _searchController.text,
            pageNumber: currentPage,
            pageSize: pageSize,
          ),
        );
        selectedProductionId = null;
        selectedLanguageId = null;
        selectedGenresId = <int>[];
        selectedActorsId = <int>[];
        selectedCategoriesId = <int>[];
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
        loadMovies(
          MovieSearchObject(
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
          title: const Text("Filmovi"),
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
                    title: const Text("Dodaj film"),
                    content: SingleChildScrollView(
                      child: AddMovieForm(),
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
                              insertMovie();
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
            if (selectedMovie.isEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Upozorenje"),
                      content: const Text(
                          "Morate odabrati barem jedan film za uređivanje"),
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
            } else if (selectedMovie.length > 1) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Upozorenje"),
                      content: const Text(
                          "Odaberite samo jedno film kojeg želite urediti"),
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
                      title: const Text("Uredi film"),
                      content: AddMovieForm(
                          isEditing: true, movieToEdit: selectedMovie[0]),
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
                              editMovie(selectedMovie[0].id);
                              setState(() {
                                selectedMovie = [];
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
          onPressed: selectedMovie.isEmpty
              ? () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: const Text("Upozorenje"),
                            content: const Text(
                                "Morate odabrati film kojeg želite obrisati."),
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
                          title: const Text("Izbriši film!"),
                          content: const SingleChildScrollView(
                            child: Text(
                                "Da li ste sigurni da želite obrisati film?"),
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
                                for (Movie n in selectedMovie) {
                                  DeleteMovie(n.id);
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

  Widget AddMovieForm({bool isEditing = false, Movie? movieToEdit}) {
    if (movieToEdit != null) {
      _titleController.text = movieToEdit.title;
      _descriptionController.text = movieToEdit.description;
      _authorController.text = movieToEdit.author;
      _relaseYearController.text = movieToEdit.releaseYear.toString();
      _durationController.text = movieToEdit.duration.toString();
      selectedProductionId = movieToEdit.productionId;
      selectedLanguageId = movieToEdit.languageId;
      _pickedFile = null;
      selectedActorsId = movieToEdit.actors.map((e) => e.id).toList();
      selectedCategoriesId =
          movieToEdit.categories?.map((e) => e.id).toList() ?? List.empty();
      selectedGenresId =
          movieToEdit.genres?.map((e) => e.id).toList() ?? List.empty();
    } else {
      _titleController.text = '';
      _descriptionController.text = '';
      _authorController.text = '';
      _relaseYearController.text = '';
      _durationController.text = '';
      _pickedFile = null;
      selectedLanguageId = null;
      selectedProductionId = null;
      selectedActorsId = <int>[];
      selectedCategoriesId = <int>[];
      selectedGenresId = <int>[];
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
                                          child: const Text('Odaberite sliku'),
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
                    controller: _durationController,
                    decoration: const InputDecoration(labelText: 'Trajanje'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Unesite trajanje!';
                      }
                      return null;
                    },
                  ),
                  MultiSelectDialogField<int>(
                    items: genres
                        .map((genre) => MultiSelectItem<int>(
                              genre.id,
                              genre.name,
                            ))
                        .toList(),
                    initialValue: selectedGenresId,
                    searchable: true,
                    listType: MultiSelectListType.LIST,
                    onConfirm: (List<int> values) {
                      selectedGenresId = values;
                    },
                    title: const Text('Odaberi žanrove'),
                    buttonText: const Text('Odaberi žanrove'),
                    dialogHeight: 400,
                    dialogWidth: 400,
                    selectedColor: Colors.teal,
                  ),
                  MultiSelectDialogField<int>(
                    items: categories
                        .map((category) => MultiSelectItem<int>(
                              category.id,
                              category.name,
                            ))
                        .toList(),
                    initialValue: selectedCategoriesId,
                    searchable: true,
                    listType: MultiSelectListType.LIST,
                    onConfirm: (List<int> values) {
                      selectedCategoriesId = values;
                    },
                    title: const Text('Odaberi kategorije'),
                    buttonText: const Text('Odaberi kategorije'),
                    dialogHeight: 400,
                    dialogWidth: 400,
                    selectedColor: Colors.teal,
                  ),
                  MultiSelectDialogField<int>(
                    items: actors
                        .map((actor) => MultiSelectItem<int>(
                              actor.id,
                              '${actor.firstName} ${actor.lastName}',
                            ))
                        .toList(),
                    initialValue: selectedActorsId,
                    searchable: true,
                    listType: MultiSelectListType.LIST,
                    onConfirm: (List<int> values) {
                      selectedActorsId = values;
                    },
                    title: const Text('Odaberi glumce'),
                    buttonText: const Text('Odaberi glumce'),
                    dialogHeight: 400,
                    dialogWidth: 400,
                    selectedColor: Colors.teal,
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
                dataRowHeight: 80,
                dataRowColor: MaterialStateProperty.all(
                    const Color.fromARGB(42, 241, 241, 241)),
                columns: [
                  DataColumn(
                      label: Checkbox(
                          value: isAllSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              isAllSelected = value ?? false;
                              for (var movieItem in movies) {
                                movieItem.isSelected = isAllSelected;
                              }
                              if (!isAllSelected) {
                                selectedMovie.clear();
                              } else {
                                selectedMovie = List.from(movies);
                              }
                            });
                          })),
                  const DataColumn(
                    label: Expanded(child: Text('Naziv')),
                  ),
                  const DataColumn(
                    label: Text('Slika'),
                  ),
                  const DataColumn(
                    label: Expanded(child: Text('Autor')),
                  ),
                  const DataColumn(
                    label: Text('Godina'),
                  ),
                  const DataColumn(
                    label: Text('Trajanje'),
                  ),
                  const DataColumn(
                    label: Text('Produkcija'),
                  ),
                ],
                rows: movies
                    .map((Movie movieItem) => DataRow(cells: [
                          DataCell(
                            Checkbox(
                              value: movieItem.isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  movieItem.isSelected = value ?? false;
                                  if (movieItem.isSelected == true) {
                                    selectedMovie.add(movieItem);
                                  } else {
                                    selectedMovie.remove(movieItem);
                                  }
                                  isAllSelected =
                                      movies.every((u) => u.isSelected);
                                });
                              },
                            ),
                          ),
                          DataCell(Text(movieItem.title.toString())),
                          DataCell(
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: FutureBuilder<String>(
                                    future: loadPhoto(
                                        movieItem.photo?.guidId ?? ''),
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
                                                headers: Authorization
                                                    .createHeaders(),
                                              ),
                                              placeholder: MemoryImage(
                                                  kTransparentImage),
                                              fadeInDuration: const Duration(
                                                  milliseconds: 300),
                                              fit: BoxFit.fill,
                                              width: 80,
                                              height: 105,
                                            ),
                                          );
                                        } else {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Image.asset(
                                              'assets/images/user2.png',
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
                          DataCell(Center(
                            child: Text(movieItem.author.toString()),
                          )),
                          DataCell(Text(movieItem.releaseYear.toString())),
                          DataCell(Text(movieItem.duration.toString())),
                          DataCell(Text(
                              movieItem.production?.name.toString() ?? '')),
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
              loadMovies(MovieSearchObject(
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
              loadMovies(
                MovieSearchObject(
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

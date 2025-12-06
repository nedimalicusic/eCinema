// ignore_for_file: library_private_types_in_public_api

import 'package:ecinema_admin/helpers/constants.dart';
import 'package:ecinema_admin/models/category.dart';
import 'package:ecinema_admin/models/cinema.dart';
import 'package:ecinema_admin/models/reservation.dart';
import 'package:ecinema_admin/models/searchObject/category_search.dart';
import 'package:ecinema_admin/providers/category_provider.dart';
import 'package:ecinema_admin/providers/cinema_provider.dart';
import 'package:ecinema_admin/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import '../../models/genre.dart';
import '../../models/movie.dart';
import '../../models/searchObject/cinema_search.dart';
import '../../models/searchObject/genre_search.dart';
import '../../models/searchObject/movie_search.dart';
import '../../models/searchObject/user_search.dart';
import '../../models/user.dart';
import '../../models/user_for_selection.dart';
import 'package:pdf/pdf.dart';
import '../../providers/genre_provider.dart';
import '../../providers/movie_provider.dart';
import '../../utils/error_dialog.dart';
import 'package:flutter/services.dart' show rootBundle;

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late CinemaProvider _cinemaProvider;
  late UserProvider _userProvider;
  late GenreProvider _genreProvider;
  late CategoryProvider _categoryProvider;
  late MovieProvider _movieProvider;

  List<Reservation> reservations = <Reservation>[];
  List<Cinema> cinemas = <Cinema>[];
  List<Genre> genres = <Genre>[];
  List<Category> categories = <Category>[];
  List<Movie> movies = <Movie>[];
  List<User> users1 = <User>[];

  UserForSelection? selectedUser;
  DateTime? fromDate;
  DateTime? toDate;
  int? selectedGender;

  int pageSize = 10000;
  int hasNextPage = 0;
  int currentPage = 1;
  bool isAllSelected = false;

  int? selectedGenreId;
  int? selectedCategoryId;

  Cinema? cinema;

  String _selectedIsActive = 'Svi';
  bool? isActive;

  @override
  void initState() {
    super.initState();
    fromDate = DateTime.now();
    toDate = DateTime.now();
    _cinemaProvider = CinemaProvider();
    _genreProvider = context.read<GenreProvider>();
    _categoryProvider = context.read<CategoryProvider>();
    _movieProvider = context.read<MovieProvider>();
    _userProvider = UserProvider();

    loadUsers();
    loadCinema(CinemaSearchObject(pageNumber: 1, pageSize: 100));
    loadMovies(MovieSearchObject());
    loadGenres(GenreSearchObject(pageNumber: 1, pageSize: 100));
    loadCategories(CategorySerchObject(pageNumber: 1, pageSize: 100));
  }

  void loadGenres(GenreSearchObject searchObject) async {
    try {
      var genreResponse = await _genreProvider.getPaged(searchObject: searchObject);
      setState(() {
        genres = genreResponse;
        hasNextPage = genres.length;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadCategories(CategorySerchObject searchObject) async {
    try {
      var categoriesResponse = await _categoryProvider.getPaged(searchObject: searchObject);
      setState(() {
        categories = categoriesResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadUsers() async {
    UserSearchObject searchObject = UserSearchObject(
      pageNumber: 1,
      pageSize: 100,
      isActive: isActive,
      gender: selectedGender,
      role: 1,
    );
    try {
      var usersResponse = await _userProvider.getPaged(searchObject: searchObject);
      setState(() {
        users1 = usersResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadMovies(MovieSearchObject searchObject) async {
    try {
      var moviesResponse = await _movieProvider.getPaged(searchObject: searchObject);
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

  void loadCinema(CinemaSearchObject searchObject) async {
    try {
      var cinemaResponse = await _cinemaProvider.getPaged(searchObject: searchObject);
      setState(() {
        cinemas = cinemaResponse;
        hasNextPage = cinemas.length;
        if (cinemas.isNotEmpty && cinema == null) {
          cinema = cinemas.first;
        }
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Izvještaji"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kino:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DropdownButton<Cinema>(
                        isExpanded: true,
                        value: cinema,
                        icon: const Icon(Icons.arrow_drop_down_outlined),
                        underline: const SizedBox(),
                        items: cinemas.map((c) {
                          return DropdownMenuItem<Cinema>(
                            value: c,
                            child: Text(c.name),
                          );
                        }).toList(),
                        onChanged: (Cinema? newValue) {
                          setState(() {
                            cinema = newValue;
                          });
                        },
                        hint: const Text('Odaberite kino'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          buildUsersReport(),
                          const SizedBox(
                            width: 20,
                          ),
                          buildMoviesReport(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildUsersReport() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Izvještaj o klijentima",
              style: TextStyle(fontSize: 20, color: white),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '  Spol:',
                      style: TextStyle(color: white),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: DropdownButton<int>(
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down_outlined),
                        value: selectedGender,
                        items: <int?>[null, 0, 1].map((int? value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                value == null
                                    ? 'Svi'
                                    : value == 0
                                        ? 'Muški'
                                        : 'Ženski',
                                style: TextStyle(
                                  color: selectedGender == value ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedGender = newValue;
                            loadUsers();
                          });
                        },
                        underline: Container(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  '  Status:',
                  style: TextStyle(color: white),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text(
                      "Aktivni računi",
                      style: TextStyle(color: Colors.white),
                    ),
                    value: _selectedIsActive,
                    icon: const Icon(Icons.arrow_drop_down_outlined),
                    items: <String>['Svi', 'Aktivni', 'Neaktivni'].map((String a) {
                      return DropdownMenuItem<String>(
                        value: a,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            a,
                            style: TextStyle(
                              color: _selectedIsActive == a ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedIsActive = newValue ?? 'Svi';

                        if (_selectedIsActive == 'Aktivni') {
                          isActive = true;
                        } else if (_selectedIsActive == 'Neaktivni') {
                          isActive = false;
                        } else {
                          isActive = null;
                        }

                        loadUsers();
                      });
                    },
                    underline: const SizedBox(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    onPressed: _displayUserPdf,
                    child: const Text(
                      'Prikaži PDF',
                      style: TextStyle(color: white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildMoviesReport() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Izvještaj o filmovima",
              style: TextStyle(fontSize: 20, color: white),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '  Žanr:',
                      style: TextStyle(color: white),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: DropdownButton<int?>(
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down_outlined),
                        value: selectedGenreId,
                        items: [
                          DropdownMenuItem<int?>(
                            value: null,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Svi',
                                style: TextStyle(
                                  color: selectedGenreId == null ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          ...genres.map((Genre genre) {
                            return DropdownMenuItem<int?>(
                              value: genre.id,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  genre.name,
                                  style: TextStyle(
                                    color: selectedGenreId == genre.id ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedGenreId = newValue;
                          });

                          loadMovies(
                            MovieSearchObject(
                              pageNumber: 1,
                              pageSize: 100,
                              genreId: selectedGenreId,
                              categoryId: selectedCategoryId,
                            ),
                          );
                        },
                        underline: Container(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  '  Kategorija:',
                  style: TextStyle(color: white),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButton<int?>(
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down_outlined),
                    value: selectedCategoryId,
                    items: [
                      DropdownMenuItem<int?>(
                        value: null,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Svi',
                            style: TextStyle(
                              color: selectedCategoryId == null ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      ...categories.map((Category category) {
                        return DropdownMenuItem<int?>(
                          value: category.id,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              category.name,
                              style: TextStyle(
                                color: selectedCategoryId == category.id ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedCategoryId = newValue;
                      });

                      loadMovies(
                        MovieSearchObject(
                          pageNumber: 1,
                          pageSize: 100,
                          genreId: selectedGenreId,
                          categoryId: selectedCategoryId,
                        ),
                      );
                    },
                    underline: const SizedBox(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    onPressed: _displayCinemaPdf,
                    child: const Text(
                      'Prikaži PDF',
                      style: TextStyle(color: white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _displayUserPdf() async {
    if (users1.isEmpty) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: const Text('Nema klijenata za odabrane filtere'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ));
      return;
    }

    final doc = pw.Document();
    final logoBytes = await rootBundle.load('assets/images/logo.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    const maxsPerPage = 20;

    for (var i = 0; i < users1.length; i += maxsPerPage) {
      final endIndex = (i + maxsPerPage < users1.length) ? i + maxsPerPage : users1.length;

      final pageUser = users1.sublist(i, endIndex);

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Image(logoImage, width: 70, height: 70),
                    pw.SizedBox(width: 20),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Cinema Name: ${cinema?.name ?? ""}',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                        pw.Text('Address: ${cinema?.address ?? ""}', style: const pw.TextStyle(fontSize: 10)),
                        pw.Text('Phone Number: ${cinema?.phoneNumber ?? ""}', style: const pw.TextStyle(fontSize: 10)),
                        pw.Text('Email: ${cinema?.email ?? ""}', style: const pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Center(
                  child: pw.Text(
                    'Izvjestaj o klijentima',
                    style: const pw.TextStyle(fontSize: 20),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Aktivnost: $_selectedIsActive',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.Text(
                  'Spol: ${selectedGender == null ? 'Svi' : selectedGender == 0 ? 'Muški' : 'Ženski'}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  context: context,
                  data: <List<String>>[
                    <String>['Ime i prezime', 'Email', 'Broj', 'Aktivan'],
                    for (var user in pageUser)
                      <String>[
                        '${user.firstName} ${user.lastName}',
                        (user.email),
                        '${user.phoneNumber}',
                        (user.isActive ? "Da" : "Ne"),
                      ],
                  ],
                  cellAlignments: {
                    0: pw.Alignment.centerLeft,
                    1: pw.Alignment.center,
                    2: pw.Alignment.center,
                    3: pw.Alignment.center,
                    4: pw.Alignment.center,
                  },
                  border: pw.TableBorder.all(),
                  headerDecoration: const pw.BoxDecoration(
                    color: PdfColors.grey,
                  ),
                  headerHeight: 25,
                  cellHeight: 25,
                ),
                if (endIndex == users1.length) ...[
                  pw.SizedBox(height: 10),
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Text('Ukupno korisnika: ${users1.length}'),
                      pw.SizedBox(height: 20),
                      pw.Text('Potpis ovlastene osobe'),
                      pw.SizedBox(height: 20),
                      pw.Container(width: 100, child: pw.Divider()),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                ],
              ],
            );
          },
        ),
      );
    }

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(doc: doc),
      ),
    );
  }

  void _displayCinemaPdf() async {
    if (movies.isEmpty) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: const Text('Nema filmova za odabrane filtere'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ));
      return;
    }

    final doc = pw.Document();
    final logoBytes = await rootBundle.load('assets/images/logo.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    const maxsPerPage = 20;

    String genreFilterText = 'Svi';
    if (selectedGenreId != null && genres.isNotEmpty) {
      final selected = genres.firstWhere(
        (g) => g.id == selectedGenreId,
        orElse: () => genres.first,
      );
      genreFilterText = selected.name;
    }

    String categoryFilterText = 'Svi';
    if (selectedCategoryId != null && categories.isNotEmpty) {
      final selected = categories.firstWhere(
        (c) => c.id == selectedCategoryId,
        orElse: () => categories.first,
      );
      categoryFilterText = selected.name;
    }

    for (var i = 0; i < movies.length; i += maxsPerPage) {
      final endIndex = (i + maxsPerPage < movies.length) ? i + maxsPerPage : movies.length;
      final pageMovies = movies.sublist(i, endIndex);

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Image(logoImage, width: 70, height: 70),
                    pw.SizedBox(width: 20),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Cinema Name: ${cinema?.name ?? ""}',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                        pw.Text('Address: ${cinema?.address ?? ""}', style: const pw.TextStyle(fontSize: 10)),
                        pw.Text('Phone Number: ${cinema?.phoneNumber ?? ""}', style: const pw.TextStyle(fontSize: 10)),
                        pw.Text('Email: ${cinema?.email ?? ""}', style: const pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Center(
                  child: pw.Text(
                    'Izvjestaj o filmovima',
                    style: const pw.TextStyle(fontSize: 20),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Zanr: $genreFilterText',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.Text(
                  'Kategorija: $categoryFilterText',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  context: context,
                  data: <List<String>>[
                    <String>['Naziv', 'Trajanje', 'Godina izdavanja', 'Autor', 'Opis'],
                    for (var movie in pageMovies)
                      <String>[
                        movie.title,
                        movie.duration.toString(),
                        movie.releaseYear.toString(),
                        movie.author,
                        movie.description,
                      ],
                  ],
                  cellAlignments: {
                    0: pw.Alignment.centerLeft,
                    1: pw.Alignment.center,
                    2: pw.Alignment.center,
                  },
                  border: pw.TableBorder.all(),
                  headerDecoration: const pw.BoxDecoration(
                    color: PdfColors.grey,
                  ),
                  headerHeight: 25,
                  cellHeight: 25,
                ),
                if (endIndex == movies.length) ...[
                  pw.SizedBox(height: 10),
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Text('Ukupno filmova: ${movies.length}'),
                      pw.SizedBox(height: 20),
                      pw.Text('Potpis ovlastene osobe'),
                      pw.SizedBox(height: 20),
                      pw.Container(width: 100, child: pw.Divider()),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                ],
              ],
            );
          },
        ),
      );
    }

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(doc: doc),
      ),
    );
  }
}

class PreviewScreen extends StatelessWidget {
  final pw.Document doc;

  const PreviewScreen({
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        centerTitle: true,
        title: const Text("Pregled"),
      ),
      body: PdfPreview(
        build: (format) => doc.save(),
        allowSharing: true,
        allowPrinting: true,
        initialPageFormat: PdfPageFormat.a4,
        pdfFileName: "mydoc.pdf",
      ),
    );
  }
}

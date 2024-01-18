// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:ecinema_admin/models/cinema.dart';
import 'package:ecinema_admin/models/movie.dart';
import 'package:ecinema_admin/models/searchObject/show_search.dart';
import 'package:ecinema_admin/models/shows.dart';
import 'package:ecinema_admin/providers/movie_provider.dart';
import 'package:ecinema_admin/providers/show_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../helpers/constants.dart';
import '../../providers/cinema_provider.dart';
import '../../utils/error_dialog.dart';

class ShowsScreen extends StatefulWidget {
  const ShowsScreen({Key? key}) : super(key: key);

  @override
  State<ShowsScreen> createState() => _ShowsScreenState();
}

class _ShowsScreenState extends State<ShowsScreen> {
  List<Shows> shows = <Shows>[];
  List<Movie> movies = <Movie>[];
  late ShowProvider _showProvider;
  late MovieProvider _movieProvider;
  late CinemaProvider _cinemaProvider;
  List<Cinema> cinemaList = <Cinema>[];
  Cinema? selectedCinema;
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime selecteTime = DateTime.now();
  int? selectedMovieId;
  int? selectedCinemaId;
  List<String> formats = ["2D", "3D", "Extreme", "4D"];
  String? selectedFormat;
  List<Shows> selectedShow = <Shows>[];
  bool isAllSelected = false;
  int currentPage = 1;
  int pageSize = 5;
  int hasNextPage = 0;

  @override
  void initState() {
    super.initState();
    _showProvider = context.read<ShowProvider>();
    _cinemaProvider = context.read<CinemaProvider>();
    _movieProvider = context.read<MovieProvider>();
    loadCinema();
    loadMovies();
    loadShows(ShowSearchObject(
        name: _searchController.text,
        cinemaId: selectedCinemaId,
        pageSize: pageSize,
        pageNumber: currentPage));

    _searchController.addListener(() {
      final searchQuery = _searchController.text;
      loadShows(ShowSearchObject(
        name: searchQuery,
        pageNumber: currentPage,
        pageSize: pageSize,
        cinemaId: selectedCinemaId,
      ));
    });
  }

  void loadCinema() async {
    try {
      var cinemasResponse = await _cinemaProvider.get(null);
      setState(() {
        cinemaList = cinemasResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadShows(ShowSearchObject searchObject) async {
    try {
      var showResponse =
          await _showProvider.getPaged(searchObject: searchObject);
      setState(() {
        shows = showResponse;
        hasNextPage = shows.length;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadMovies() async {
    try {
      var moviesResponse = await _movieProvider.get(null);
      setState(() {
        movies = moviesResponse;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void InsertShow() async {
    try {
      var newShow = {
        "date": _dateController.text,
        "startTime": _timeController.text,
        "movieId": selectedMovieId,
        "cinemaId": selectedCinemaId,
        "format": selectedFormat,
        "price": _priceController.text
      };
      var city = await _showProvider.insert(newShow);
      if (city == "OK") {
        Navigator.of(context).pop();
        loadShows(
          ShowSearchObject(
            name: _searchController.text,
            cinemaId: null,
            pageNumber: currentPage,
            pageSize: pageSize,
          ),
        );
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void EditShow(int id) async {
    try {
      var newShow = {
        "id": id,
        "date": _dateController.text,
        "startTime": _timeController.text,
        "movieId": selectedMovieId,
        "cinemaId": selectedCinemaId,
        "format": selectedFormat,
        "price": _priceController.text
      };
      var city = await _showProvider.edit(newShow);
      if (city == "OK") {
        Navigator.of(context).pop();
        loadShows(
          ShowSearchObject(
            name: _searchController.text,
            cinemaId: null,
            pageNumber: currentPage,
            pageSize: pageSize,
          ),
        );
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void DeleteShow(int id) async {
    try {
      var actor = await _showProvider.delete(id);
      if (actor == "OK") {
        Navigator.of(context).pop();
        loadShows(
          ShowSearchObject(
            name: _searchController.text,
            cinemaId: null,
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
          title: const Text("Projekcije"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              buildFilterDropdowns(),
              const SizedBox(height: 16.0),
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

  Row buildFilterDropdowns() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('  Pretraga po kinima:'),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DropdownButton<Cinema>(
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  value: selectedCinema,
                  items: [
                    const DropdownMenuItem<Cinema>(
                      value: null,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('Svi'),
                      ),
                    ),
                    ...cinemaList.map((Cinema cinema) {
                      return DropdownMenuItem<Cinema>(
                        value: cinema,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(cinema.name),
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: (Cinema? newValue) {
                    setState(() {
                      selectedCinema = newValue;
                    });
                    if (selectedCinema == null) {
                      loadShows(
                        ShowSearchObject(
                          cinemaId: null,
                          name: _searchController.text,
                          pageNumber: currentPage,
                          pageSize: pageSize,
                        ),
                      );
                    } else {
                      loadShows(
                        ShowSearchObject(
                          cinemaId: selectedCinema!.id,
                          name: _searchController.text,
                          pageNumber: currentPage,
                          pageSize: pageSize,
                        ),
                      );
                    }
                  },
                  underline: const Text(""),
                ),
              ),
            ],
          ),
        ),
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
                    title: const Text("Dodaj projekciju"),
                    content: SingleChildScrollView(
                      child: AddShowForm(),
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
                              InsertShow();
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
            if (selectedShow.isEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Upozorenje"),
                      content: const Text(
                          "Morate odabrati barem jednu projekciju za uređivanje"),
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
            } else if (selectedShow.length > 1) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Upozorenje"),
                      content: const Text(
                          "Odaberite samo jednu projekciju kojeg želite urediti"),
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
                      content: AddShowForm(
                          isEditing: true, showToEdit: selectedShow[0]),
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
                              EditShow(selectedShow[0].id);
                              setState(() {
                                selectedShow = [];
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
          onPressed: selectedShow.isEmpty
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
                                for (Shows n in selectedShow) {
                                  DeleteShow(n.id);
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

  Widget AddShowForm({bool isEditing = false, Shows? showToEdit}) {
    if (showToEdit != null) {
      _priceController.text = showToEdit.price.toString();
      _dateController.text =
          DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(showToEdit.date);
      _timeController.text =
          DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(showToEdit.startTime);
      selectedCinemaId = showToEdit.cinemaId;
      selectedMovieId = showToEdit.movieId;
      selectedFormat = showToEdit.format;
    } else {
      _priceController.text = '';
      _dateController.text = '';
      _timeController.text = '';
      selectedCinemaId = null;
      selectedMovieId = null;
      selectedFormat = null;
    }

    return SizedBox(
      height: 400,
      width: 700,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              value: selectedCinemaId,
              onChanged: (int? newValue) {
                setState(() {
                  selectedCinemaId = newValue;
                });
              },
              items: cinemaList.map((Cinema cinema) {
                return DropdownMenuItem<int>(
                  value: cinema.id,
                  child: Text(cinema.name),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Kino'),
              validator: (value) {
                if (value == null) {
                  return 'Odaberite kino!';
                }
                return null;
              },
            ),
            DropdownButtonFormField<int>(
              value: selectedMovieId,
              onChanged: (int? newValue) {
                setState(() {
                  selectedMovieId = newValue;
                });
              },
              items: movies.map((Movie movie) {
                return DropdownMenuItem<int>(
                  value: movie.id,
                  child: Text(movie.title),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Film'),
              validator: (value) {
                if (value == null) {
                  return 'Odaberite film!';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Datum',
                hintText: 'Odaberite datum',
              ),
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2101),
                ).then((date) {
                  if (date != null) {
                    setState(() {
                      selectedDate = date;
                      _dateController.text =
                          DateFormat('yyyy-MM-dd').format(date);
                    });
                  }
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Unesite datum!';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'Vrijeme',
                hintText: 'Odaberite vrijeme',
              ),
              onTap: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(selecteTime),
                ).then((time) {
                  if (time != null) {
                    setState(() {
                      selecteTime = DateTime(
                          selecteTime.year,
                          selecteTime.month,
                          selecteTime.day,
                          time.hour,
                          time.minute);
                      _timeController.text =
                          DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ')
                              .format(selecteTime);
                    });
                  }
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Unesite vrijeme!';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: selectedFormat,
              onChanged: (String? newValue) {
                setState(() {
                  selectedFormat = newValue;
                });
              },
              items: formats.map((String format) {
                return DropdownMenuItem<String>(
                  value: format,
                  child: Text(format),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Format'),
              validator: (value) {
                if (value == null) {
                  return 'Odaberite format!';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Cijena'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Unesite cijenu!';
                }
                return null;
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
                              for (var employeeItem in shows) {
                                employeeItem.isSelected = isAllSelected;
                              }
                              if (!isAllSelected) {
                                selectedShow.clear();
                              } else {
                                selectedShow = List.from(shows);
                              }
                            });
                          })),
                  const DataColumn(
                    label: Expanded(child: Text('Datum')),
                  ),
                  const DataColumn(
                    label: Text('Početak'),
                  ),
                  const DataColumn(
                    label: Text('Film'),
                  ),
                  const DataColumn(
                    label: Text('Format'),
                  ),
                  const DataColumn(
                    label: Text('Cijena'),
                  ),
                ],
                rows: shows
                    .map((Shows showItem) => DataRow(cells: [
                          DataCell(
                            Checkbox(
                              value: showItem.isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  showItem.isSelected = value ?? false;
                                  if (showItem.isSelected == true) {
                                    selectedShow.add(showItem);
                                  } else {
                                    selectedShow.remove(showItem);
                                  }
                                  isAllSelected =
                                      shows.every((u) => u.isSelected);
                                });
                              },
                            ),
                          ),
                          DataCell(Text(showItem.date.toString())),
                          DataCell(Text(showItem.startTime.toString())),
                          DataCell(Text(showItem.movie.toString())),
                          DataCell(Text(showItem.format.toString())),
                          DataCell(Text(showItem.price.toString())),
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
              loadShows(ShowSearchObject(
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
              loadShows(ShowSearchObject(
                  pageNumber: currentPage,
                  pageSize: pageSize,
                  name: _searchController.text));
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

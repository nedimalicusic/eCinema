// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:ecinema_admin/models/cinema.dart';
import 'package:ecinema_admin/models/movie.dart';
import 'package:ecinema_admin/models/searchObject/show_search.dart';
import 'package:ecinema_admin/models/show_type.dart';
import 'package:ecinema_admin/models/shows.dart';
import 'package:ecinema_admin/providers/movie_provider.dart';
import 'package:ecinema_admin/providers/reccuring_show_provider.dart';
import 'package:ecinema_admin/providers/show_provider.dart';
import 'package:ecinema_admin/providers/show_type_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../helpers/constants.dart';
import '../../models/week_day.dart';
import '../../providers/cinema_provider.dart';
import '../../providers/week_days_provider.dart';
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
  late ShowTypeProvider _showTypeProvider;
  late WeekDayProvider _weekDayProvider;
  late ReccuringShowProvider _reccuringShowProvider;
  List<Cinema> cinemaList = <Cinema>[];
  List<WeekDay> weekDays = <WeekDay>[];
  List<ShowType> showtypes = <ShowType>[];
  Cinema? selectedCinema;
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final _formKeySecond = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _startDateTimeController = TextEditingController();
  final TextEditingController _endDateTimeController = TextEditingController();
  final TextEditingController _reccuringStartDate = TextEditingController();
  final TextEditingController _reccuringEndDate = TextEditingController();
  DateTime selectedreccuringStartDate = DateTime.now();
  DateTime selectedreccuringEndDate = DateTime.now();
  DateTime selectedreccuringTime = DateTime.now();

  DateTime selectedDateStart = DateTime.now();
  DateTime selecteDateEnd = DateTime.now();
  int? selectedMovieId;
  int? selectedCinemaId;
  int? selectedShowTypeId;
  int? selectWeekDayId;
  List<Shows> selectedShow = <Shows>[];
  bool isAllSelected = false;
  bool isReccuringShow = false;
  late ValueNotifier<bool> _isReccuringShow;
  int currentPage = 1;
  int pageSize = 5;
  int hasNextPage = 0;

  @override
  void initState() {
    super.initState();
    _showProvider = context.read<ShowProvider>();
    _cinemaProvider = context.read<CinemaProvider>();
    _movieProvider = context.read<MovieProvider>();
    _showTypeProvider = context.read<ShowTypeProvider>();
    _weekDayProvider = context.read<WeekDayProvider>();
    _reccuringShowProvider = context.read<ReccuringShowProvider>();
    _isReccuringShow = ValueNotifier<bool>(isReccuringShow);
    loadCinema();
    loadMovies();
    loadShowTypes();
    loadWeekDays();
    loadShows(ShowSearchObject(name: _searchController.text, cinemaId: selectedCinemaId, pageSize: pageSize, pageNumber: currentPage));

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
      if (mounted) {
        setState(() {
          cinemaList = cinemasResponse;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadShows(ShowSearchObject searchObject) async {
    try {
      var showResponse = await _showProvider.getPaged(searchObject: searchObject);
      if (mounted) {
        setState(() {
          shows = showResponse;
          hasNextPage = shows.length;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadWeekDays() async {
    try {
      var weekDayResponse = await _weekDayProvider.get(null);
      if (mounted) {
        setState(() {
          weekDays = weekDayResponse;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadShowTypes() async {
    try {
      var showtypesResponse = await _showTypeProvider.get(null);
      if (mounted) {
        setState(() {
          showtypes = showtypesResponse;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void loadMovies() async {
    try {
      var moviesResponse = await _movieProvider.get(null);
      if (mounted) {
        setState(() {
          movies = moviesResponse;
        });
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void InsertShow(int? reccuringShowId) async {
    try {
      var newShow = {
        "MovieId": selectedMovieId,
        "CinemaId": selectedCinemaId,
        "ShowTypeId": selectedShowTypeId,
        "Price": _priceController.text,
        "StartsAt": DateTime.parse(_startDateTimeController.text).toUtc().toIso8601String(),
        "EndsAt": DateTime.parse(_endDateTimeController.text).toUtc().toIso8601String(),
        "RecurringShowId": reccuringShowId,
      };
      var show = await _showProvider.insert(newShow);
      if (show == "OK") {
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

  void InsertReccuringShow(bool isEdit, int? showId) async {
    try {
      var showTime = TimeOfDay.fromDateTime(DateTime.parse(_startDateTimeController.text));
      var newReccuringShow = {
        "StartingDate": DateTime.parse(_reccuringStartDate.text).toUtc().toIso8601String(),
        "EndingDate": DateTime.parse(_reccuringEndDate.text).toUtc().toIso8601String(),
        "ShowTime": Duration(hours: showTime.hour, minutes: showTime.minute).toString(),
        "WeekDayId": selectWeekDayId,
      };
      var recurringShow = await _reccuringShowProvider.insert(newReccuringShow);
      if (recurringShow.id > 0) {
        if (isEdit) {
          EditShow(showId!, recurringShow.id);
        } else {
          InsertShow(recurringShow.id);
        }
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void EditReccuringShow(int showId, int id) async {
    try {
      var showTime = TimeOfDay.fromDateTime(DateTime.parse(_startDateTimeController.text));
      var ediReccurinhShow = {
        "Id": id,
        "StartingDate": DateTime.parse(_reccuringStartDate.text).toUtc().toIso8601String(),
        "EndingDate": DateTime.parse(_reccuringEndDate.text).toUtc().toIso8601String(),
        "ShowTime": Duration(hours: showTime.hour, minutes: showTime.minute).toString(),
        "WeekDayId": selectWeekDayId,
      };
      var recurringShow = await _reccuringShowProvider.edit(ediReccurinhShow);
      if (recurringShow.id > 0) {
        EditShow(showId, recurringShow.id);
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void EditShow(int id, int? reccuringShowId) async {
    try {
      var editShow = {
        "Id": id,
        "MovieId": selectedMovieId,
        "CinemaId": selectedCinemaId,
        "ShowTypeId": selectedShowTypeId,
        "Price": _priceController.text,
        "StartsAt": DateTime.parse(_startDateTimeController.text).toUtc().toIso8601String(),
        "EndsAt": DateTime.parse(_endDateTimeController.text).toUtc().toIso8601String(),
        "RecurringShowId": reccuringShowId,
      };
      var show = await _showProvider.edit(editShow);
      if (show == "OK") {
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
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                          child: const Text("Zatvori", style: TextStyle(color: white))),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          onPressed: () {
                            if (_isReccuringShow.value) {
                              if (_formKeySecond.currentState!.validate() && _formKey.currentState!.validate()) {
                                InsertReccuringShow(false, null);
                              }
                            } else {
                              if (_formKey.currentState!.validate()) {
                                InsertShow(null);
                              }
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
            if (selectedShow.isEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Upozorenje"),
                      content: const Text("Morate odabrati barem jednu projekciju za uređivanje"),
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
            } else if (selectedShow.length > 1) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Upozorenje"),
                      content: const Text("Odaberite samo jednu projekciju kojeg želite urediti"),
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
                      title: const Text("Uredi projekciju"),
                      content: AddShowForm(isEditing: true, showToEdit: selectedShow[0]),
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
                              if (selectedShow[0].recurringShowId != null && selectedShow[0].recurringShowId! > 0) {
                                if (_isReccuringShow.value) {
                                  if (_formKeySecond.currentState!.validate() && _formKey.currentState!.validate()) {
                                    EditReccuringShow(selectedShow[0].id, selectedShow[0].recurringShowId!);
                                  }
                                } else {
                                  if (_formKey.currentState!.validate()) {
                                    EditShow(selectedShow[0].id, null);
                                  }
                                }
                              } else {
                                if (_isReccuringShow.value) {
                                  if (_formKeySecond.currentState!.validate() && _formKey.currentState!.validate()) {
                                    InsertReccuringShow(true, selectedShow[0].id);
                                  }
                                } else {
                                  if (_formKey.currentState!.validate()) {
                                    EditShow(selectedShow[0].id, null);
                                  }
                                }
                              }
                              setState(() {
                                selectedShow = [];
                              });
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
          onPressed: selectedShow.isEmpty
              ? () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(title: const Text("Upozorenje"), content: const Text("Morate odabrati projekciju koju želite obrisati."), actions: <Widget>[
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
                          title: const Text("Izbriši projekciju!"),
                          content: const SingleChildScrollView(
                            child: Text("Da li ste sigurni da želite obrisati projekciju?"),
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
                                for (Shows n in selectedShow) {
                                  DeleteShow(n.id);
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
    );
  }

  Widget AddShowForm({bool isEditing = false, Shows? showToEdit}) {
    if (showToEdit?.recurringShowId != null) {
      _isReccuringShow.value = true;
    }
    if (showToEdit != null) {
      selectedCinemaId = showToEdit.cinemaId;
      selectedMovieId = showToEdit.movieId;
      selectedShowTypeId = showToEdit.showTypeId;
      _priceController.text = showToEdit.price.toString();
      _startDateTimeController.text = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(showToEdit.startsAt);
      _endDateTimeController.text = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(showToEdit.endsAt);
      if (showToEdit.recurringShowId != null) {
        isReccuringShow = true;
        selectWeekDayId = showToEdit.reccuringShow!.weekDayId;
        _reccuringStartDate.text = DateFormat('yyyy-MM-dd').format(showToEdit.reccuringShow!.startingDate);
        _reccuringEndDate.text = DateFormat('yyyy-MM-dd').format(showToEdit.reccuringShow!.endingDate);
      } else {
        isReccuringShow = false;
        selectWeekDayId = null;
        _reccuringStartDate.text = '';
        _reccuringEndDate.text = '';
      }
    } else {
      _priceController.text = '';
      _startDateTimeController.text = '';
      _endDateTimeController.text = '';
      selectedCinemaId = null;
      selectedMovieId = null;
      isReccuringShow = false;
      selectedShowTypeId = null;
      selectWeekDayId = null;
      _reccuringStartDate.text = '';
      _reccuringEndDate.text = '';
    }

    return SizedBox(
      height: 515,
      width: 700,
      child: Row(children: [
        Form(
          key: _formKey,
          child: Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
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
                      controller: _startDateTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Početni datum i vrijeme',
                        hintText: 'Odaberite početak',
                      ),
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: selectedDateStart,
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2101),
                        ).then((date) {
                          if (date != null) {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(selectedDateStart),
                            ).then((time) {
                              if (time != null) {
                                setState(() {
                                  selectedDateStart = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    time.hour,
                                    time.minute,
                                  );
                                  _startDateTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(selectedDateStart);
                                });
                              }
                            });
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Unesite datum i vrijeme početka!';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _endDateTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Završni datum i vrijeme',
                        hintText: 'Odaberite završetak',
                      ),
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: selecteDateEnd,
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2101),
                        ).then((date) {
                          if (date != null) {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(selecteDateEnd),
                            ).then((time) {
                              if (time != null) {
                                setState(() {
                                  selecteDateEnd = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    time.hour,
                                    time.minute,
                                  );
                                  _endDateTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(selecteDateEnd);
                                });
                              }
                            });
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Unesite datum i vrijeme završetka!';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<int>(
                      value: selectedShowTypeId,
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedShowTypeId = newValue;
                        });
                      },
                      items: showtypes.map((ShowType showType) {
                        return DropdownMenuItem<int>(
                          value: showType.id,
                          child: Text(showType.name),
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
            ),
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        Form(
          key: _formKeySecond,
          child: Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: _isReccuringShow,
                      builder: (context, isActive, child) {
                        if (_isReccuringShow.value) {
                          isReccuringShow = true;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _isReccuringShow.value,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isReccuringShow.value = !_isReccuringShow.value;
                                      });
                                    },
                                  ),
                                  const Text('Redovna projekcija'),
                                ],
                              ),
                              DropdownButtonFormField<int>(
                                value: selectWeekDayId,
                                onChanged: (int? newValue) {
                                  setState(() {
                                    selectWeekDayId = newValue;
                                  });
                                },
                                items: weekDays.map((WeekDay weekDay) {
                                  return DropdownMenuItem<int>(
                                    value: weekDay.id,
                                    child: Text(weekDay.name),
                                  );
                                }).toList(),
                                decoration: const InputDecoration(labelText: 'Dan u sedmici'),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Odaberite dan!';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _reccuringStartDate,
                                decoration: const InputDecoration(
                                  labelText: 'Datum početka',
                                  hintText: 'Odaberite datum početka',
                                ),
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: selectedreccuringStartDate,
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime(2101),
                                  ).then((date) {
                                    if (date != null) {
                                      setState(() {
                                        selectedreccuringStartDate = date;
                                        _reccuringStartDate.text = DateFormat('yyyy-MM-dd').format(date);
                                      });
                                    }
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Unesite datum početka!';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _reccuringEndDate,
                                decoration: const InputDecoration(
                                  labelText: 'Datum kraja',
                                  hintText: 'Odaberite datum kraja',
                                ),
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: selectedreccuringEndDate,
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime(2101),
                                  ).then((date) {
                                    if (date != null) {
                                      setState(() {
                                        selectedreccuringEndDate = date;
                                        _reccuringEndDate.text = DateFormat('yyyy-MM-dd').format(date);
                                      });
                                    }
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Unesite datum kraja!';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          );
                        } else {
                          isReccuringShow = false;
                          return Row(
                            children: [
                              Checkbox(
                                value: _isReccuringShow.value,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isReccuringShow.value = !_isReccuringShow.value;
                                  });
                                },
                              ),
                              const Text('Redovna projekcija'),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
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
                dataRowHeight: 80,
                dataRowColor: MaterialStateProperty.all(const Color.fromARGB(42, 241, 241, 241)),
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
                    label: Expanded(child: Text('Početak')),
                  ),
                  const DataColumn(
                    label: Expanded(child: Text('Kraj')),
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
                                  isAllSelected = shows.every((u) => u.isSelected);
                                });
                              },
                            ),
                          ),
                          DataCell(Text(DateFormat('dd.MM.yyyy HH:mm').format(showItem.startsAt))),
                          DataCell(Text(DateFormat('dd.MM.yyyy HH:mm').format(showItem.endsAt))),
                          DataCell(Text(showItem.movie.title.toString())),
                          DataCell(Text(showItem.showType.name.toString())),
                          DataCell(Text('${showItem.price.toString()} KM')),
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
              loadShows(ShowSearchObject(pageNumber: currentPage, pageSize: pageSize, name: _searchController.text));
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

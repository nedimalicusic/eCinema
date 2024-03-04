// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:ecinema_admin/models/reservation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../helpers/constants.dart';
import '../../models/cinema.dart';
import '../../models/searchObject/reservation_search.dart';
import '../../providers/cinema_provider.dart';
import '../../providers/reservation_provider.dart';
import '../../utils/error_dialog.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({Key? key}) : super(key: key);

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Reservation> reservations = <Reservation>[];
  final TextEditingController _searchController = TextEditingController();
  late ReservationProvider _reservationProvider;
  late CinemaProvider _cinemaProvider;
  late ValueNotifier<bool> _isActiveNotifier;
  late ValueNotifier<bool> _isConfirmNotifier;
  List<Cinema> cinemaList = <Cinema>[];
  Cinema? selectedCinema;
  bool isEditing = false;
  String? selectedMovie;
  String? selectedUser;
  String? selectedSeat;
  int? selectedShowId;
  int? selectedSeatId;
  int? selectedUserId;
  bool isActive = false;
  int? selectedCinemaId;
  bool isConfirm = false;
  bool _isReservationActive = false;
  bool _isReservationConfirm = false;
  bool isAllSelected = false;
  int currentPage = 1;
  int pageSize = 5;
  int hasNextPage = 0;
  List<Reservation> selectedReservation = <Reservation>[];

  @override
  void initState() {
    super.initState();
    _reservationProvider = context.read<ReservationProvider>();
    _cinemaProvider = context.read<CinemaProvider>();
    _isConfirmNotifier = ValueNotifier<bool>(_isReservationConfirm);
    _isActiveNotifier = ValueNotifier<bool>(_isReservationActive);
    loadCinema();
    loadReservation(ReservationSearchObject(
        name: _searchController.text,
        pageSize: pageSize,
        cinemaId: selectedCinemaId,
        pageNumber: currentPage));

    _searchController.addListener(() {
      final searchQuery = _searchController.text;
      loadReservation(ReservationSearchObject(
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

  void loadReservation(ReservationSearchObject searchObject) async {
    try {
      var reservationResponse =
          await _reservationProvider.getPaged(searchObject: searchObject);
      setState(() {
        reservations = reservationResponse;
        hasNextPage = reservations.length;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void EditReservation(int id) async {
    try {
      var editReservation = {
        "id": id,
        "showId": selectedShowId,
        "seatId": selectedSeatId,
        "userId": selectedUserId,
        "isActive": _isReservationActive,
        "isConfirm": _isReservationConfirm,
      };
      var reservation = await _reservationProvider.edit(editReservation);
      if (reservation == "OK") {
        Navigator.of(context).pop();
        loadReservation(
          ReservationSearchObject(
            name: _searchController.text,
            pageNumber: currentPage,
            cinemaId: null,
            pageSize: pageSize,
          ),
        );
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  void DeleteReservation(int id) async {
    try {
      var actor = await _reservationProvider.delete(id);
      if (actor == "OK") {
        Navigator.of(context).pop();
        loadReservation(
          ReservationSearchObject(
              name: _searchController.text,
              pageNumber: currentPage,
              pageSize: pageSize,
              cinemaId: null),
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
          title: const Text("Rezervacije"),
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
                      loadReservation(
                        ReservationSearchObject(
                          cinemaId: null,
                          name: _searchController.text,
                          pageNumber: currentPage,
                          pageSize: pageSize,
                        ),
                      );
                    } else {
                      loadReservation(
                        ReservationSearchObject(
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
            minimumSize: const Size(40, 40),
            backgroundColor: primaryColor,
          ),
          onPressed: () {
            if (selectedReservation.isEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Upozorenje"),
                      content: const Text(
                          "Morate odabrati barem jednu rezervaciju za uređivanje"),
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
            } else if (selectedReservation.length > 1) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Upozorenje"),
                      content: const Text(
                          "Odaberite samo jednu rezervaciju koju želite urediti"),
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
                      title: const Text("Uredi rezervaciju"),
                      content: EditReservationForm(
                          isEditing: true,
                          reservationToEdit: selectedReservation[0]),
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
                              EditReservation(selectedReservation[0].id);
                              setState(() {
                                selectedReservation = [];
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
          onPressed: selectedReservation.isEmpty
              ? () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: const Text("Upozorenje"),
                            content: const Text(
                                "Morate odabrati rezervaciju koju želite obrisati."),
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
                          title: const Text("Izbriši rezervaciju!"),
                          content: const SingleChildScrollView(
                            child: Text(
                                "Da li ste sigurni da želite obrisati rezervaciju?"),
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
                                for (Reservation n in selectedReservation) {
                                  DeleteReservation(n.id);
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

  Widget EditReservationForm(
      {bool isEditing = false, Reservation? reservationToEdit}) {
    if (reservationToEdit != null) {
      selectedCinemaId = reservationToEdit.show.cinemaId;
      selectedShowId = reservationToEdit.showId;
      selectedMovie = reservationToEdit.show.movie.title;
      selectedSeatId = reservationToEdit.seatId;
      selectedUser =
          "${reservationToEdit.user.firstName} ${reservationToEdit.user.lastName}";
      selectedUserId = reservationToEdit.userId;
      selectedSeat =
          '${reservationToEdit.seat.row.toString()}${reservationToEdit.seat.column.toString()}';
      _isActiveNotifier.value = reservationToEdit.isActive;
      _isConfirmNotifier.value = reservationToEdit.isConfirm;
      selectedCinemaId = null;
    }

    return SizedBox(
      height: 340,
      width: 350,
      child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Kino'),
            enabled: false,
            initialValue: selectedCinema?.name,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Film'),
            enabled: false,
            initialValue: selectedMovie,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Sjedalo'),
            enabled: false,
            initialValue: selectedSeat,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Korisnik'),
            enabled: false,
            initialValue: selectedUser,
          ),
          const SizedBox(
            height: 20,
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isActiveNotifier,
            builder: (context, isActive, child) {
              return Row(
                children: [
                  Checkbox(
                    value: _isActiveNotifier.value,
                    onChanged: (bool? value) {
                      _isActiveNotifier.value = !_isActiveNotifier.value;
                      _isReservationActive = _isActiveNotifier.value;
                    },
                  ),
                  const Text('Aktivan'),
                ],
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isConfirmNotifier,
            builder: (context, isConfirm, child) {
              return Row(
                children: [
                  Checkbox(
                    value: _isConfirmNotifier.value,
                    onChanged: (bool? value) {
                      _isConfirmNotifier.value = !_isConfirmNotifier.value;
                      _isReservationConfirm = _isConfirmNotifier.value;
                    },
                  ),
                  const Text('Potvrdjena'),
                ],
              );
            },
          ),
        ]),
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
                              for (var reservationItem in reservations) {
                                reservationItem.isSelected = isAllSelected;
                              }
                              if (!isAllSelected) {
                                selectedReservation.clear();
                              } else {
                                selectedReservation = List.from(reservations);
                              }
                            });
                          })),
                  const DataColumn(
                    label: Expanded(child: Text('Kino')),
                  ),
                  const DataColumn(
                    label: Text('Film'),
                  ),
                  const DataColumn(
                    label: Text('Sjedalo'),
                  ),
                  const DataColumn(
                    label: Text('Aktivna'),
                  ),
                  const DataColumn(
                    label: Text('Potvrdjena'),
                  ),
                ],
                rows: reservations
                    .map((Reservation reservationItem) => DataRow(cells: [
                          DataCell(
                            Checkbox(
                              value: reservationItem.isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  reservationItem.isSelected = value ?? false;
                                  if (reservationItem.isSelected == true) {
                                    selectedReservation.add(reservationItem);
                                  } else {
                                    selectedReservation.remove(reservationItem);
                                  }
                                  isAllSelected =
                                      reservations.every((u) => u.isSelected);
                                });
                              },
                            ),
                          ),
                          DataCell(Text(
                              reservationItem.show.cinema.name.toString())),
                          DataCell(Text(
                              reservationItem.show.movie.title.toString())),
                          DataCell(Text(
                              '${reservationItem.seat.row.toString()}${reservationItem.seat.column.toString()}')),
                          DataCell(Container(
                            alignment: Alignment.center,
                            child: reservationItem.isActive == true
                                ? const Icon(
                                    Icons.check_circle_outline,
                                    color: green,
                                    size: 30,
                                  )
                                : const Icon(
                                    Icons.close_outlined,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                          )),
                          DataCell(Container(
                            alignment: Alignment.center,
                            child: reservationItem.isConfirm == true
                                ? const Icon(
                                    Icons.check_circle_outline,
                                    color: green,
                                    size: 30,
                                  )
                                : const Icon(
                                    Icons.close_outlined,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                          )),
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
              loadReservation(ReservationSearchObject(
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
              loadReservation(ReservationSearchObject(
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

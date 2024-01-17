// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:ecinema_admin/models/reservation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  late ValueNotifier<bool> _isActiveNotifier;
  late ValueNotifier<bool> _isConfirmNotifier;
  bool isEditing = false;
  String? selectedCinema;
  String? selectedMovie;
  String? selectedUser;
  String? selectedSeat;
  int? selectedShowId;
  int? selectedSeatId;
  int? selectedUserId;
  bool isActive = false;
  bool isConfirm = false;
  bool _isReservationActive = false;
  bool _isReservationConfirm = false;

  @override
  void initState() {
    super.initState();
    _reservationProvider = context.read<ReservationProvider>();
    _isConfirmNotifier = ValueNotifier<bool>(_isReservationConfirm);
    _isActiveNotifier = ValueNotifier<bool>(_isReservationActive);
    loadReservations('');
    _searchController.addListener(() {
      final searchQuery = _searchController.text;
      loadReservations(searchQuery);
    });
  }

  void loadReservations(String? query) async {
    var params;
    try {
      if (query != null) {
        params = query;
      } else {
        params = null;
      }
      var reservationsResponse =
          await _reservationProvider.get({'params': params});
      setState(() {
        reservations = reservationsResponse;
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
      var city = await _reservationProvider.edit(editReservation);
      if (city == "OK") {
        Navigator.of(context).pop();
        loadReservations('');
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
        loadReservations('');
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
          width: 1180,
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

  Widget EditReservationForm(
      {bool isEditing = false, Reservation? reservationToEdit}) {
    if (reservationToEdit != null) {
      selectedCinema = reservationToEdit.show.cinema.name;
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
            initialValue: selectedCinema,
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

  Widget _buildDataListView() {
    return Expanded(
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
              columns: const [
                DataColumn(
                    label: Expanded(
                  child: Text(
                    "ID",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text(
                    "Cinema",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text(
                    "Movie",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text(
                    "Seat",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  flex: 5,
                  child: Text(
                    "Active",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  flex: 5,
                  child: Text(
                    "Confirm",
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
              rows: reservations
                  .map((Reservation e) => DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(e.show.cinema.name.toString())),
                        DataCell(Text(e.show.movie.title.toString())),
                        DataCell(Text(
                            '${e.seat.row.toString()}${e.seat.column.toString()}')),
                        DataCell(Text(e.isActive.toString())),
                        DataCell(Text(e.isConfirm.toString())),
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
                                        ? 'Uredi rezervaciju'
                                        : 'Dodaj rezervaciju'),
                                    content: SingleChildScrollView(
                                      child: EditReservationForm(
                                          isEditing: isEditing,
                                          reservationToEdit: e),
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
                                            EditReservation(e.id);
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
                                    title: const Text("Izbrisi rezervaciju"),
                                    content: const SingleChildScrollView(
                                        child: Text(
                                            "Da li ste sigurni da zelite obisati rezervaciju?")),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Odustani'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          DeleteReservation(e.id);
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

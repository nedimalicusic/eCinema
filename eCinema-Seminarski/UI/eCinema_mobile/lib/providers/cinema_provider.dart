import 'package:ecinema_mobile/models/cinema.dart';
import 'base_provider.dart';

class CinemaProvider extends BaseProvider<Cinema> {
  CinemaProvider() : super('Cinema/GetPaged');

  late Cinema _selectedCinema;

  setSelectedCinema(Cinema cinema) {
    _selectedCinema = cinema;
  }

  getSelectCinema() {
    return _selectedCinema;
  }

  @override
  Cinema fromJson(data) {
    return Cinema.fromJson(data);
  }
}

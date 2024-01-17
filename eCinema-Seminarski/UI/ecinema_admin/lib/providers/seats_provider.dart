import 'package:ecinema_admin/models/seats.dart';
import 'base_provider.dart';

class SeatsProvider extends BaseProvider<Seats> {
  SeatsProvider() : super('Seats/GetPaged');

  @override
  Seats fromJson(data) {
    return Seats.fromJson(data);
  }
}

import '../models/week_day.dart';
import 'base_provider.dart';

class WeekDayProvider extends BaseProvider<WeekDay> {
  WeekDayProvider() : super('WeekDay/GetPaged');

  @override
  WeekDay fromJson(data) {
    return WeekDay.fromJson(data);
  }
}

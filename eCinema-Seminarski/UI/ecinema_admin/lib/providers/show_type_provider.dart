import 'package:ecinema_admin/models/show_type.dart';

import 'base_provider.dart';

class ShowTypeProvider extends BaseProvider<ShowType> {
  ShowTypeProvider() : super('ShowType/GetPaged');

  @override
  ShowType fromJson(data) {
    return ShowType.fromJson(data);
  }
}

import 'package:fe/order/models/model.dart';

class ScreenArguments {
  ScreenArguments({
    this.screenTitle,
    this.orderType,
    this.status,
    this.order,
  });

  final String screenTitle;
  final String orderType;
  final List<String> status;
  final Order order;
}

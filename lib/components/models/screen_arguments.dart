import 'package:fe/order/models/model.dart';

class ScreenArguments {
  ScreenArguments({
    this.screenTitle,
    this.orderType,
    this.status,
    this.order,
    this.item,
  });

  final String screenTitle;
  final Set<String> orderType;
  final Set<String> status;
  final Order order;
  final Item item;
}

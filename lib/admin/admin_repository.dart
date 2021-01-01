import 'dart:convert';
import 'dart:core';

import 'package:fe/order/order.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

class AdminRepository {
  AdminRepository();

  Future<List<Order>> loadOrders({
    @required String userID,
    @required String orderType,
    @required String status,
  }) async {
    var url =
        '${FlutterConfig.get('BASE_URL')}/admin/$userID/orders/$orderType/status/$status';
    print(url);
    var response = await get(url);

    var body = json.decode(response.body) as List;
    print(body);

    if (response.statusCode == 200) {
      var orders = body.map((e) => Order.fromJson(e)).toList();
      return orders;
    } else {
      return [];
    }
  }

  Future<List<Item>> loadOrderItems({
    @required String orderID,
  }) async {
    var url = '${FlutterConfig.get('BASE_URL')}/orders/$orderID/items';
    print(url);
    var response = await get(url);

    var body = json.decode(response.body) as List;
    print(body);

    if (response.statusCode == 200) {
      var items = body.map((e) => Item.fromJson(e)).toList();
      return items;
    } else {
      return [];
    }
  }
}

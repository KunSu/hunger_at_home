import 'dart:convert';
import 'dart:core';

import 'package:fe/order/order.dart';
import 'package:fe/order_detail/order_detail.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

class OrderDetailRepository {
  OrderDetailRepository();

  Future<OrderDetail> loadOrderDetail({
    @required String userID,
    @required String orderID,
  }) async {
    var url = '${env['BASE_URL']}/users/$userID/orders/$orderID/info';
    print(url);
    var response = await get(url);

    var body = json.decode(response.body);
    print(body);

    if (response.statusCode == 200) {
      var newOrderDetail = OrderDetail.fromJson(body);
      return newOrderDetail;
    } else {
      throw (body['message']);
    }
  }

  Future<List<Item>> loadOrderItems({
    @required String orderID,
  }) async {
    var url = '${env['BASE_URL']}/orders/$orderID/items';
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

import 'dart:convert';
import 'dart:core';

import 'package:fe/order/models/order.dart';
import 'package:http/http.dart';

class OrdersRepository {
  OrdersRepository() {
    orders = <Order>[];
  }
  List<Order> orders;
  List<Order> loadOrders() {
    return orders;
  }

  saveOrders(List<Order> orders) {
    orders = orders ?? this.orders;
  }

// TODO: getAllOrders and POST Order
  Future<List<Order>> init({String userID}) async {
    var url =
        'http://localhost:8080/api/v1/order/getOrderListByDonorID/$userID/all/10';
    print(url);
    var response = await get(url);

    if (response.statusCode == 200) {
      var body = json.decode(response.body) as List;
      orders.clear();
      orders.addAll(body.map((e) => Order.fromJson(e)).toList());
      return orders;
    } else {
      // TODO: error
      var body = json.decode(response.body);
      throw Exception(body['message']);
    }
  }

  // TODO: can be void
  Future<Order> signUp({String addressID, Order order}) async {
    var url = 'http://localhost:8080/api/v1/order/addWholeOrder';
    print(url);

    var headers = <String, String>{'Content-type': 'application/json'};
    var jsonData =
        '{"addressID": "$addressID", "note": "NA", "orderType": "donation", "pickUpTime": "${order.pickupDateAndTime}", "status": "pending"}';
    print(jsonData);
    var response = await post(url, headers: headers, body: jsonData);

    if (response.statusCode == 201 || response.statusCode == 200) {
      var body = json.decode(response.body);
      print(body);
      var newOrders = Order.fromJson(body);
      orders.add(newOrders);
      return newOrders;
    } else {
      // TODO: error
      var body = json.decode(response.body);
      throw Exception(body['message']);
    }
  }
}

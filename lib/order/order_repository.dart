import 'dart:convert';
import 'dart:core';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/order/models/model.dart';
import 'package:flutter_config/flutter_config.dart';
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

  Future<List<Order>> reload({User user, String status}) async {
    // TODO: fix the URL
    var url;
    switch (user.userIdentity) {
      case 'donor':
        url =
            '${FlutterConfig.get('BASE_URL')}/donor/${user.id}/status/$status/amount/100';
        break;
      case 'employee':
        url =
            '${FlutterConfig.get('BASE_URL')}/employee/${user.id}/status/$status/amount/100';
        break;
      case 'recipient':
        url =
            '${FlutterConfig.get('BASE_URL')}/recipient/${user.id}/status/$status/amount/100';
        break;
      default:
        break;
    }

    print(url);
    var response = await get(url);

    if (response.statusCode == 200) {
      var body = json.decode(response.body) as List;
      orders.clear();
      orders.addAll(body.map((e) => Order.fromJson(e)).toList());
      return orders;
    } else {
      var body = json.decode(response.body);
      throw (body['message']);
    }
  }

  Future<Order> signUp(
      {String userID,
      String addressID,
      String orderType,
      String pickUpTime,
      String status,
      List<Item> orderItems}) async {
    var url = '${FlutterConfig.get('BASE_URL')}/order';
    print(url);

    var headers = <String, String>{'Content-type': 'application/json'};

    final Map<String, dynamic> jsonData = Map<String, dynamic>();
    jsonData['addressID'] = addressID;
    jsonData['note'] = 'NA';
    jsonData['pickUpTime'] = pickUpTime;
    jsonData['items'] = orderItems.map((e) => e.toJSON()).toList();
    jsonData['userID'] = userID;

    print(json.encode(jsonData));
    var response =
        await post(url, headers: headers, body: json.encode(jsonData));

    var body = json.decode(response.body);
    if (response.statusCode == 201) {
      var newOrder = Order.fromJson(body);
      //TODO: simplify
      for (var item in body['items'] as List) {
        newOrder.items.add(Item.fromJson(item));
      }
      // orders.add(newOrder);
      return newOrder;
    } else {
      throw (body['message']);
    }
  }

  Future<Order> update({String userID, String orderID, String status}) async {
    var url =
        '${FlutterConfig.get('BASE_URL')}/users/$userID/orders/$orderID/status/$status';
    print(url);

    var headers = <String, String>{'Content-type': 'application/json'};

    var response = await patch(url, headers: headers);

    var body = json.decode(response.body);
    if (response.statusCode == 200) {
      var newOrder = Order.fromJson(body);
      orders.add(newOrder);
      return newOrder;
    } else {
      throw (body['message']);
    }
  }
}

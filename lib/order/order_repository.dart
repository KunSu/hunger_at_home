import 'dart:convert';
import 'dart:core';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/order/models/model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

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
            '${env['BASE_URL']}/donor/${user.id}/orders?status=all&amount=100';
        break;
      case 'employee':
        url =
            '${env['BASE_URL']}/employee/${user.id}/orders?status=all&amount=100';
        break;
      case 'recipient':
        url =
            '${env['BASE_URL']}/recipient/${user.id}/orders?status=all&amount=100';
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

  Future<Order> signUp({
    String userID,
    String addressID,
    String orderType,
    String pickUpTime,
    String status,
    List<Item> orderItems,
  }) async {
    var url = '${env['BASE_URL']}/order';
    print(url);

    var headers = <String, String>{'Content-type': 'application/json'};

    final Map<String, dynamic> jsonData = Map<String, dynamic>();
    jsonData['addressID'] = addressID;
    jsonData['orderType'] = orderType;
    jsonData['note'] = 'NA';
    if (orderType != 'dropoff') {
      jsonData['pickUpTime'] = pickUpTime;
    }
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
      return newOrder;
    } else {
      throw (body['message']);
    }
  }

  Future<Order> update({String userID, String orderID, String status}) async {
    var url = '${env['BASE_URL']}/users/$userID/orders/$orderID/status/$status';
    print(url);

    var headers = <String, String>{'Content-type': 'application/json'};

    var response = await patch(url, headers: headers);

    var body = json.decode(response.body);
    if (response.statusCode == 200) {
      var newOrder = Order.fromJson(body);
      return newOrder;
    } else {
      throw (body['message']);
    }
  }

  Future<List<Order>> loadOrdersByAdmin({
    @required String userID,
    @required Set<String> orderType,
    @required Set<String> status,
  }) async {
    var url =
        '${env['BASE_URL']}/admin/$userID/orders?orderType=${orderType.toList().join(',')}&status=${status.toList().join(',')}';

    print(url);
    var response = await get(url);

    var body = json.decode(response.body) as List;
    print(body);

    var orders = <Order>[];
    if (response.statusCode == 200) {
      orders = body.map((e) => Order.fromJson(e)).toList();
    }
    return orders;
  }

  Future<List<Item>> loadOrderItems({
    @required String orderID,
  }) async {
    var url = '${env['BASE_URL']}/orders/$orderID/items';
    // print(url);
    var response = await get(url);

    var body = json.decode(response.body) as List;
    // print(body);

    if (response.statusCode == 200) {
      var items = body.map((e) => Item.fromJson(e)).toList();
      return items;
    } else {
      return [];
    }
  }

  Future<Order> editOrder({
    @required String userID,
    @required String addressID, // It is not used for API
    @required String orderType,
    @required String pickUpTime,
    @required Order order,
  }) async {
    var url = '${env['BASE_URL']}/order';
    print(url);

    var headers = <String, String>{'Content-type': 'application/json'};

    final Map<String, dynamic> jsonData = Map<String, dynamic>();
    jsonData['userID'] = userID;
    jsonData['orderID'] = order.id;
    jsonData['addressID'] = addressID; // It is not used for API
    jsonData['orderType'] = orderType;
    jsonData['note'] = 'NA';
    if (orderType != 'dropoff' && orderType != 'anonymous') {
      jsonData['pickUpTime'] = pickUpTime;
    }
    jsonData['items'] = order.items.map((e) => e.toJSON()).toList();

    print(json.encode(jsonData));
    var response =
        await patch(url, headers: headers, body: json.encode(jsonData));

    var body = json.decode(response.body);
    if (response.statusCode == 200) {
      var newOrder = Order.fromJson(body);
      //TODO: simplify
      for (var item in body['items'] as List) {
        newOrder.items.add(Item.fromJson(item));
      }
      return newOrder;
    } else {
      throw body['message'];
    }
  }

  Future<Order> anonymousOrder({
    @required String userID,
    @required String addressID,
    @required String orderType,
    @required List<Item> items,
  }) async {
    var url = '${env['BASE_URL']}/anonymousOrder';
    print(url);

    var headers = <String, String>{'Content-type': 'application/json'};

    final jsonData = <String, dynamic>{};
    jsonData['userID'] = userID;
    jsonData['addressID'] = addressID;
    jsonData['orderType'] = orderType;
    jsonData['note'] = 'NA';
    jsonData['items'] = items.map((e) => e.toJSON()).toList();

    print(json.encode(jsonData));
    var response =
        await post(url, headers: headers, body: json.encode(jsonData));

    var body = json.decode(response.body);
    if (response.statusCode == 201) {
      var newOrder = Order.fromJson(body);
      // TODO: simplify
      for (var item in body['items'] as List) {
        newOrder.items.add(Item.fromJson(item));
      }
      if (newOrder.pickupDateAndTime == null) {
        newOrder = newOrder.copyWith(pickupDateAndTime: 'Not Available');
      }
      return newOrder;
    } else {
      throw body['message'];
    }
  }

  Future<List<Order>> loadOrderSummary({
    @required String userID,
    @required String startDate,
    @required String endDate,
    @required Set<String> type,
    @required Set<String> status,
  }) async {
    var url =
        '${env['BASE_URL']}/admin/$userID/report?startDate=$startDate&endDate=$endDate&orderType=${type.toList().join(',')}&status=${status.toList().join(',')}&download=false';
    print(url);
    var response = await get(url);

    var body = json.decode(response.body) as List;
    print(body);

    if (response.statusCode == 200) {
      orders.clear();
      // TODO: simplify
      for (var order in body) {
        var newOrder = Order.fromJson(order);
        for (var item in order['items'] as List) {
          newOrder.items.add(Item.fromJson(item));
        }
        if (newOrder.pickupDateAndTime == null) {
          newOrder = newOrder.copyWith(pickupDateAndTime: 'Not Available');
        }
        orders.add(newOrder);
      }
    } else {
      throw json.decode(response.body)['message'];
    }
    return orders;
  }

  Future<String> downloadOrderSummary({
    @required String userID,
    @required String startDate,
    @required String endDate,
    @required Set<String> type,
    @required Set<String> status,
  }) async {
    var url =
        '${env['BASE_URL']}/admin/$userID/report?startDate=$startDate&endDate=$endDate&orderType=${type.toList().join(',')}&status=${status.toList().join(',')}&download=true';
    print(url);
    var response = await get(url);

    var body = json.decode(response.body);
    print(body);

    if (response.statusCode == 200) {
      return body['path'];
    } else {
      throw body['message'];
    }
  }

  Future<Order> delivered({
    @required String userID,
    @required String orderID,
    @required String temperature,
  }) async {
    var url =
        '${env['BASE_URL']}/users/$userID/orders/$orderID/temperature/$temperature';
    print(url);

    var headers = <String, String>{'Content-type': 'application/json'};

    var response = await patch(url, headers: headers);

    var body = json.decode(response.body);
    if (response.statusCode == 200) {
      var newOrder = Order.fromJson(body);
      return newOrder;
    } else {
      throw (body['message']);
    }
  }
}

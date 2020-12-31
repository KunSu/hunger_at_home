import 'dart:convert';
import 'dart:core';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/order/models/model.dart';
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

  Future<List<Order>> reload({User user}) async {
    // TODO: fix the URL
    var url;
    switch (user.userIdentity) {
      case 'donor':
        url =
            'http://localhost:8080/api/v1/order/getOrderListByDonorID/${user.id}/all/100';
        break;
      case 'employee':
        url =
            'http://localhost:8080/api/v1/order/getOrderListByEmployeeID/${user.id}/all/100';
        break;
      case 'recipient':
        url =
            'http://localhost:8080/api/v1/order/getOrderListByRecipientID/${user.id}/all/100';
        break;
      case 'admin':
        url =
            'http://localhost:8080/api/v1/order/getOrderListByDonorID/${user.id}/all/100';
        break;
      default:
        break;
    }

    print(url);
    var response = await get(url);

    if (response.statusCode == 200 || response.statusCode == 201) {
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
    var url = 'http://localhost:8080/api/v1/order/addWholeOrder';
    print(url);

    // TODO: waiting for Zijian
    var headers = <String, String>{'Content-type': 'application/json'};

    // final Map<String, dynamic> jsonData = Map<String, dynamic>();
    // jsonData['addressID'] = addressID;
    // jsonData['note'] = 'NA';
    // jsonData['orderType'] = orderType;
    // jsonData['pickUpTime'] = pickUpTime;
    // jsonData['status'] = status;
    // jsonData['orderItems'] = orderItems.map((e) => e.toJSON()).toList();
    // print(jsonData['orderItems']);
    var jsonData = '''{
          "addressID": "$addressID",
          "note": "NA",
          "orderItems": [
            {
              "expireDate": "2019-09-09",
              "foodCategory": "fruit",
              "foodName": "apple",
              "quantity": "1",
              "temperature": "3C",
              "unit": "kg"
            }
          ],
          "orderType": "$orderType",
          "pickUpTime": "$pickUpTime",
          "status": "$status"
        }''';
    // print(jsonEncode(jsonData));
    // var response =
    //     await post(url, headers: headers, body: jsonEncode(jsonData));
    var response = await post(url, headers: headers, body: jsonData);

    var body = json.decode(response.body);
    if (response.statusCode == 201) {
      var newOrder = Order.fromJson(body);
      //TODO: simplify
      for (var item in body['orderItems'] as List) {
        newOrder.items.add(Item.fromJson(item));
      }
      orders.add(newOrder);
      return newOrder;
    } else {
      throw (body['message']);
    }
  }

  Future<Order> update({String userID, String orderID, String status}) async {
    var url =
        'http://localhost:8080/api/v1/order/updateOrderStatus/$orderID/$status';
    print(url);

    var headers = <String, String>{'Content-type': 'application/json'};

    // final Map<String, dynamic> jsonData = Map<String, dynamic>();
    // jsonData['addressID'] = addressID;
    // jsonData['note'] = 'NA';
    // jsonData['orderType'] = orderType;
    // jsonData['pickUpTime'] = pickUpTime;
    // jsonData['status'] = status;
    // jsonData['orderItems'] = orderItems.map((e) => e.toJSON()).toList();
    // print(jsonData['orderItems']);
    // var jsonData = '''{
    //       "addressID": "$addressID",
    //       "note": "NA",
    //       "orderItems": [
    //         {
    //           "expireDate": "2019-09-09",
    //           "foodCategory": "fruit",
    //           "foodName": "apple",
    //           "quantity": "1",
    //           "temperature": "3C",
    //           "unit": "kg"
    //         }
    //       ],
    //       "orderType": "$orderType",
    //       "pickUpTime": "$pickUpTime",
    //       "status": "$status"
    //     }''';
    // print(jsonEncode(jsonData));
    // var response =
    //     await post(url, headers: headers, body: jsonEncode(jsonData));
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

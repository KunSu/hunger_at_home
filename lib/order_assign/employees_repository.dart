import 'dart:convert';
import 'dart:core';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

class EmployeesRepository {
  EmployeesRepository() {
    employees = <User>[];
  }

  List<User> employees;

  Future<List<User>> getAllEmployees() async {
    var url = '${FlutterConfig.get('BASE_URL')}/employees';
    print(url);
    var response = await get(url);

    var body = json.decode(response.body) as List;
    print(body);

    if (response.statusCode == 200) {
      employees.clear();
      for (var user in body) {
        employees.add(User.fromJson(user));
      }
      return employees;
    } else {
      return [];
    }
  }

  String getEmployeeID({String email}) {
    for (var i = 0; i < employees.length; i++) {
      if (employees[i].email == email) {
        return employees[i].id;
      }
    }
    return '-1';
  }

  Future<String> assignOrderToEmployee({
    @required String userID,
    @required String orderID,
    @required String employeeID,
  }) async {
    var url =
        '${FlutterConfig.get('BASE_URL')}/orderAssociate/$userID/$orderID/$employeeID/approved';
    print(url);

    var headers = <String, String>{'Content-type': 'application/json'};
    var response = await patch(url, headers: headers);

    var body = json.decode(response.body);
    if (response.statusCode == 200) {
      return body['message'];
    } else {
      throw body['message'];
    }
  }

  Future<User> approveNewUser({
    @required String userID,
    @required String email,
    @required String status,
  }) async {
    var url = '${FlutterConfig.get('BASE_URL')}/user/$userID/$email/$status';
    print(url);

    var headers = <String, String>{'Content-type': 'application/json'};
    var response = await patch(url, headers: headers);

    var body = json.decode(response.body);
    if (response.statusCode == 200) {
      return User.fromJson(body);
    } else {
      throw body['message'];
    }
  }
}

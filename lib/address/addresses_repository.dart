import 'dart:convert';
import 'dart:core';

import 'package:fe/address/address.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart';

class AddressesRepository {
  AddressesRepository() {
    addresses = <Address>[];
  }
  List<Address> addresses;
  List<Address> loadAddresses() {
    return addresses;
  }

  Future<List<String>> loadAddressNames({String companyID}) async {
    var url = '${FlutterConfig.get('BASE_URL')}/companies/$companyID/addresses';
    print(url);
    var response = await get(url);

    if (response.statusCode == 200) {
      var body = json.decode(response.body) as List;
      print(body);

      addresses.clear();
      addresses.addAll(body.map((e) => Address.fromJson(e)).toList());
      return addresses.map((e) => e.address).toList();
    } else {
      var body = json.decode(response.body);
      throw (body['message']);
    }
  }

  String getAddressID(String address) {
    for (var i = 0; i < addresses.length; i++) {
      if (addresses[i].address == address) {
        return addresses[i].id;
      }
    }
    return '-1';
  }

  saveAddresses(List<Address> addresses) {
    addresses = addresses ?? this.addresses;
  }

  Future<Address> signUp(
      {String userID,
      String address,
      String city,
      String state,
      String zipCode}) async {
    var url = '${FlutterConfig.get('BASE_URL')}/address';
    print(url);

    var headers = <String, String>{'Content-type': 'application/json'};
    var jsonData =
        '{"address": "$address", "city": "$city", "state": "$state", "zipCode": "$zipCode", "userID": "$userID"}';

    print(jsonData);
    var response = await post(url, headers: headers, body: jsonData);

    var body = json.decode(response.body);
    if (response.statusCode == 201) {
      var newAdress = Address.fromJson(body);
      addresses.add(newAdress);
      return newAdress;
    } else {
      throw (body['message']);
    }
  }
}

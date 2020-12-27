import 'dart:convert';
import 'dart:core';

import 'package:fe/address/address.dart';
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
    var url = 'http://localhost:8080/api/v1/company/addressList/$companyID';
    print(url);
    var response = await get(url);

    if (response.statusCode == 200) {
      var body = json.decode(response.body) as List;
      addresses.clear();
      addresses.addAll(body.map((e) => Address.fromJson(e)).toList());
      return addresses.map((e) => e.address).toList();
    } else {
      // TODO: error
      var body = json.decode(response.body);
      throw Exception(body['message']);
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
      {String address, String city, String state, String zipCode}) async {
    var url = 'http://localhost:8080/api/v1/company/addressSignUp';
    print(url);

    var headers = <String, String>{'Content-type': 'application/json'};
    var jsonData =
        '{"address": "$address", "city": "$city", "state": "$state", "zipCode": "$zipCode"}';
    print(jsonData);
    var response = await post(url, headers: headers, body: jsonData);

    if (response.statusCode == 201) {
      var body = json.decode(response.body);

      var newAdress = Address.fromJson(body);
      addresses.add(newAdress);
      return newAdress;
    } else {
      // TODO: error
      var body = json.decode(response.body);
      throw Exception(body['message']);
    }
  }
}

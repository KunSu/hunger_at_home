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

  saveAddresses(List<Address> addresses) {
    addresses = addresses ?? this.addresses;
  }

  signUp({String address, String city, String state, String zipCode}) async {
    // set up POST request arguments
    var url = 'http://localhost:8080/api/v1/company/addressSignUp';

    var headers = <String, String>{'Content-type': 'application/json'};
    var jsonData =
        '{"address": "$address", "city": "$city", "state": "$state", "zipCode": "$zipCode"}';
    // print('jsonData: $jsonData');
    var response = await post(url, headers: headers, body: jsonData);
    // check the status code for the result
    var statusCode = response.statusCode;
    print('statusCode: $statusCode');
    // this API passes back the id of the new item added to the body
    var body = response.body;
    print(body);
    // print(body.);

    var newAddress = Address(
      id: '1',
      address: address,
      city: city,
      state: state,
      zipcode: zipCode,
    );

    if (address != null) {
      addresses.add(newAddress);
    } else {
      // TODO: error
    }
    // _user = User(id: username, username: username, useridentity: useridentity);

    // print(_user.id);
    // if (_user != null) {
    //   print('working');
    //   _controller.add(AuthenticationStatus.authenticated);
    // } else {
    //   // TODO: error
    // }
  }
}

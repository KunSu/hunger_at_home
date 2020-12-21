import 'dart:core';

import 'package:fe/address/address.dart';

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
}

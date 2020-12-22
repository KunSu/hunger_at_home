import 'dart:core';

import 'package:fe/address/address.dart';
import 'package:fe/company/bloc/company_bloc.dart';
import 'package:fe/company/models/model.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:http/http.dart';

class CompaniesRepository {
  CompaniesRepository() {
    companies = <Company>[];
  }
  List<Company> companies;
  List<Company> loadCompanies() {
    return companies;
  }

  saveCompanies(List<Company> companies) {
    companies = companies ?? this.companies;
  }

  String getCompanyID(String address) {
    for (var i = 0; i < companies.length; i++) {
      if (companies[i].address == address) {
        return companies[i].id;
      }
    }
    return '-1';
  }

  Future<Company> signUp({
    String name,
    String fedID,
    String einID,
    String address,
    String city,
    String state,
    String zipCode,
  }) async {
    // set up POST request arguments
    var url = 'http://localhost:8080/api/v1/company/companySignup';

    var headers = <String, String>{'Content-type': 'application/json'};
    var jsonData =
        '{"companyName": "$name", "fedID": "$fedID", "einID": "$einID", "address": "$address", "city": "$city", "state": "$state", "zipCode": "$zipCode"}';
    // '{"companyName": "$name", "fedID": "$fedID", "einID": "$einID"}';
    // print('jsonData: $jsonData');
    var response = await post(url, headers: headers, body: jsonData);
    // check the status code for the result
    var statusCode = response.statusCode;
    print('statusCode: $statusCode');
    // this API passes back the id of the new item added to the body
    var body = response.body;
    print(body);
    // print(body.);

    var newCompany = Company(
      id: '1',
      name: name,
      fedID: fedID,
      einID: einID,
      address: address,
      city: city,
      state: state,
      zipcode: zipCode,
    );

    if (address != null) {
      companies.add(newCompany);
    } else {
      // TODO: error
    }
    return newCompany;
  }
}

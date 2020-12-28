import 'dart:convert';
import 'dart:core';

import 'package:fe/company/models/model.dart';
import 'package:http/http.dart';

class CompaniesRepository {
  CompaniesRepository() {
    companies = <Company>[];
  }
  List<Company> companies;
  List<Company> loadCompanies() {
    return companies;
  }

  Future<List<String>> loadCompanyNames() async {
    var url = 'http://localhost:8080/api/v1/company/companyList';
    print(url);

    var response = await get(url);
    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      var body = json.decode(response.body) as List;
      companies.clear();
      companies.addAll(body.map((e) => Company.fromJson(e)).toList());

      return companies.map((e) => e.name).toList();
    } else {
      throw (body['message']);
    }
  }

  saveCompanies(List<Company> companies) {
    companies = companies ?? this.companies;
  }

  String getCompanyID(String name) {
    for (var i = 0; i < companies.length; i++) {
      if (companies[i].name == name) {
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
    var url = 'http://localhost:8080/api/v1/company/companySignup';
    print(url);

    var headers = <String, String>{'Content-type': 'application/json'};
    var jsonData =
        '{"companyName": "$name", "fedID": "$fedID", "einID": "$einID", "address": "$address", "city": "$city", "state": "$state", "zipCode": "$zipCode"}';

    var response = await post(url, headers: headers, body: jsonData);
    var body = json.decode(response.body);

    if (response.statusCode == 201) {
      var newCompany = Company.fromJson(body);
      companies.add(newCompany);
      return newCompany;
    } else {
      throw (body['message']);
    }
  }
}

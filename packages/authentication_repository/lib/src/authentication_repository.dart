import 'dart:async';
import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  User user;

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unknown;
    yield* _controller.stream;
  }

  Future<void> logIn({
    @required String email,
    @required String password,
  }) async {
    assert(email != null);
    assert(password != null);

    var url = 'http://localhost:8080/api/v1/user/login/${email}/${password}';
    print(url);

    var headers = <String, String>{'Content-type': 'application/json'};

    var response = await get(
      url,
      headers: headers,
      // body: jsonData,
    );

    var statusCode = response.statusCode;
    print('statusCode:$statusCode');

    var body = json.decode(response.body);
    print(body);

    // if (FlutterConfig.get('TESTING_MODEL') == true) {
    //   print('Tessting Login');
    //   var id = '-1';
    //   var useridentity = '';
    //   switch (email) {
    //     case 'donor@gmail.com':
    //       id = '1';
    //       useridentity = 'donor';
    //       break;
    //     case 'employee@gmail.com':
    //       id = '2';
    //       useridentity = 'employee';
    //       break;
    //     case 'recipient@gmail.com':
    //       id = '3';
    //       useridentity = 'recipient';
    //       break;
    //     case 'approver@gmail.com':
    //       id = '4';
    //       useridentity = 'approver';
    //       break;
    //     default:
    //       return Future.error ('UserName or Password error');
    //       break;
    //   }

    //   user = User(
    //     id: id,
    //     email: email,
    //     companyID: '1',
    //     useridentity: useridentity,
    //   );
    //   _controller.add(AuthenticationStatus.authenticated);
    // }
    // TODO: stateCode should not be 201
    if (statusCode == 200 || statusCode == 201) {
      user = User(
          id: body['id'],
          email: body['email'],
          companyID: body['companyID'],
          useridentity: body['userIdentity']);
      _controller.add(AuthenticationStatus.authenticated);
    } else {
      throw (body['message']);
    }
  }

  Future<void> register({
    @required String email,
    @required String password,
    @required String lastname,
    @required String firstname,
    @required String phonenumber,
    @required String useridentity,
    @required String comapnyID,
  }) async {
    assert(email != null);
    assert(password != null);
    assert(lastname != null);
    assert(firstname != null);
    assert(phonenumber != null);
    assert(useridentity != null);
    assert(comapnyID != null);

    print('comapnyID: $comapnyID');
    useridentity = useridentity.toLowerCase();

    var url = 'http://localhost:8080/api/v1/user/signup';
    print(url);

    var headers = <String, String>{'Content-type': 'application/json'};
    var jsonData =
        '{"email": "$email", "password": "$password", "firstName": "$firstname", "lastName": "$lastname", "phoneNumber": "$phonenumber", "userIdentity": "$useridentity", "companyID": "$comapnyID", "secureQuestion": "NA", "secureAnswer": "NA"}';

    var response = await post(url, headers: headers, body: jsonData);

    var statusCode = response.statusCode;

    var body = json.decode(response.body);
    print(body);

    if (statusCode == 201) {
      user = User(
        id: body['id'],
        email: body['email'],
        companyID: body['companyID'],
        useridentity: body['userIdentity'],
      );
      _controller.add(AuthenticationStatus.authenticated);
    } else {
      throw (body['message']);
    }
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  User getUser() {
    return user;
  }

  void dispose() => _controller.close();
}

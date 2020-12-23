import 'dart:async';
import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
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

    var url = 'http://localhost:8080/api/v1/user/login';

    var jsonData = '{"email": "$email", "password": "$password"}';
    var headers = <String, String>{'Content-type': 'application/json'};

    var response = await post(
      url,
      headers: headers,
      body: jsonData,
    );

    var statusCode = response.statusCode;
    print('statusCode:$statusCode');

    var body = json.decode(response.body);
    print(body);

    // TODO: stateCode should not be 201
    if (statusCode == 200 || statusCode == 201) {
      user = User(
          id: body['id'],
          email: body['email'],
          companyID: body['companyID'],
          useridentity: body['userIdentity']);
      _controller.add(AuthenticationStatus.authenticated);
    } else {
      var errorMessage = body['message'];
      throw Exception(errorMessage);
    }
  }

  void register({
    @required String email,
    @required String password,
    @required String lastname,
    @required String firstname,
    @required String phonenumber,
    @required String useridentity,
  }) async {
    assert(email != null);
    assert(password != null);
    assert(lastname != null);
    assert(firstname != null);
    assert(phonenumber != null);
    assert(useridentity != null);

    email = email.toLowerCase();
    lastname = lastname.toLowerCase();
    firstname = firstname.toLowerCase();
    useridentity = useridentity.toLowerCase();
    // set up POST request arguments
    var url = 'http://localhost:8080/api/v1/user/signup';

    var headers = <String, String>{'Content-type': 'application/json'};
    var jsonData =
        '{"email": "$email", "password": "$password", "firstName": "$firstname", "lastName": "$lastname", "phoneNumber": "$phonenumber", "userIdentity": "$useridentity", "companyID": "1", "secureQuestion": "NA", "secureAnswer": "NA"}';
    print('jsonData: $jsonData');
    var response = await post(url, headers: headers, body: jsonData);
    // check the status code for the result
    var statusCode = response.statusCode;
    print('statusCode:$statusCode');
    // this API passes back the id of the new item added to the body
    var body = response.body;
    print(body);
    // print(body.);
    if (statusCode == 201) {
      user = User(id: email, email: email, useridentity: useridentity);

      print(user.id);
      if (user != null) {
        print('working');
        _controller.add(AuthenticationStatus.authenticated);
      } else {
        // TODO: error
      }
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

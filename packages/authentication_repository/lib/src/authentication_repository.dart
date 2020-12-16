import 'dart:async';
import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  User _user;

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    @required String username,
    @required String password,
  }) async {
    assert(username != null);
    assert(password != null);

    // var url = 'http://localhost:8080/api/v1/user/login';

    // var headers = <String, String>{'Content-type': 'application/json'};
    // var jsonData = '{"email": "$username", "password": "$password"}';

    // var response = await post(url, headers: headers, body: jsonData);
    // // check the status code for the result
    // var statusCode = response.statusCode;
    // print('statusCode:$statusCode');
    // // this API passes back the id of the new item added to the body
    // var body = response.body;
    // print(body);

    _user = User(id: '1', username: username, useridentity: 'donor');
    await Future.delayed(
      const Duration(milliseconds: 300),
      () => _controller.add(AuthenticationStatus.authenticated),
    );
  }

  void register({
    @required String username,
    @required String password,
    @required String lastname,
    @required String firstname,
    @required String phonenumber,
    @required String useridentity,
  }) async {
    assert(username != null);
    assert(password != null);
    assert(lastname != null);
    assert(firstname != null);
    assert(phonenumber != null);
    assert(useridentity != null);

    // set up POST request arguments
    var url = 'http://localhost:8080/api/v1/user/signup';

    var headers = <String, String>{'Content-type': 'application/json'};
    var jsonData =
        '{"email": "$username", "password": "$password", "firstName": "$firstname", "lastName": "$lastname", "phoneNumber": "$phonenumber", "userIdentity": "$useridentity", "companyID": "1", "secureQuestion": "NA", "secureAnswer": "NA"}';
    print('jsonData: $jsonData');
    var response = await post(url, headers: headers, body: jsonData);
    // check the status code for the result
    var statusCode = response.statusCode;
    print('statusCode:$statusCode');
    // this API passes back the id of the new item added to the body
    var body = response.body;
    print(body);
    // print(body.);
    _user = User(id: username, username: username, useridentity: useridentity);

    print(_user.id);
    if (_user != null) {
      print('working');
      _controller.add(AuthenticationStatus.authenticated);
    } else {
      // TODO: error
    }
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  User getUser() {
    return _user;
  }

  void dispose() => _controller.close();
}

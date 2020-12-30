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
    //   var userIdentity = '';
    //   switch (email) {
    //     case 'donor@gmail.com':
    //       id = '1';
    //       userIdentity = 'donor';
    //       break;
    //     case 'employee@gmail.com':
    //       id = '2';
    //       userIdentity = 'employee';
    //       break;
    //     case 'recipient@gmail.com':
    //       id = '3';
    //       userIdentity = 'recipient';
    //       break;
    //     case 'approver@gmail.com':
    //       id = '4';
    //       userIdentity = 'approver';
    //       break;
    //     default:
    //       return Future.error ('UserName or Password error');
    //       break;
    //   }

    //   user = User(
    //     id: id,
    //     email: email,
    //     companyID: '1',
    //     userIdentity: userIdentity,
    //   );
    //   _controller.add(AuthenticationStatus.authenticated);
    // }
    // TODO: stateCode should not be 201
    if (statusCode == 200 || statusCode == 201) {
      // user = User(
      //     id: body['id'],
      //     email: body['email'],
      //     companyID: body['companyID'],
      //     userIdentity: body['userIdentity']);
      user = User.fromJson(body);
      _controller.add(AuthenticationStatus.authenticated);
    } else {
      throw (body['message']);
    }
  }

  Future<void> register({
    @required String email,
    @required String password,
    @required String lastName,
    @required String firstName,
    @required String phoneNumber,
    @required String userIdentity,
    @required String companyID,
  }) async {
    assert(email != null);
    assert(password != null);
    assert(lastName != null);
    assert(firstName != null);
    assert(phoneNumber != null);
    assert(userIdentity != null);
    assert(companyID != null);

    print('companyID: $companyID');
    userIdentity = userIdentity.toLowerCase();

    var url = 'http://localhost:8080/api/v1/user/signup';
    print(url);

    var headers = <String, String>{'Content-type': 'application/json'};
    var jsonData = '''{
      "companyID": "$companyID",
      "email": "$email",
      "firstName": "$firstName",
      "lastName": "$lastName",
      "password": "$password",
      "phoneNumber": "$phoneNumber",
      "userIdentity": "$userIdentity"
    }''';

    var response = await post(url, headers: headers, body: jsonData);

    var statusCode = response.statusCode;

    var body = json.decode(response.body);
    print(body);

    if (statusCode == 201) {
      // user = User(
      //   id: body['id'],
      //   email: body['email'],
      //   companyID: body['companyID'],
      //   userIdentity: body['userIdentity'],
      // );
      user = User.fromJson(body);
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

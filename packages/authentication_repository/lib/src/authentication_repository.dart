import 'dart:async';
import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

    print('${env['BASE_URL']}');
    var url = '${env['BASE_URL']}/user/$email/$password';
    print(url);

    var headers = <String, String>{'Content-type': 'application/json'};

    var response = await get(
      url,
      headers: headers,
    );

    var statusCode = response.statusCode;
    print('statusCode:$statusCode');

    var body = json.decode(response.body);
    print(body);

    if (statusCode == 200) {
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

    var url = '${env['BASE_URL']}/user';
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

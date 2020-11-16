import 'dart:async';

import 'package:meta/meta.dart';

import '../authentication_repository.dart';

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

    _user = User(username);
    await Future.delayed(
      const Duration(milliseconds: 300),
      () => _controller.add(AuthenticationStatus.authenticated),
    );
  }

  Future<void> register({
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

    _user = User(username);
    await Future.delayed(
      const Duration(milliseconds: 300),
      () => _controller.add(AuthenticationStatus.authenticated),
    );
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  User getUser() {
    return _user;
  }

  void dispose() => _controller.close();
}

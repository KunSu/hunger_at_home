import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/app.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(App(
    authenticationRepository: AuthenticationRepository(),
  ));
}

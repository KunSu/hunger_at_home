import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:fe/app.dart';
import 'package:fe/simple_bloc_observer.dart';
import 'package:flutter/widgets.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(App(
    authenticationRepository: AuthenticationRepository(),
  ));
}

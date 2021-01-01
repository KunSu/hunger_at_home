import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:fe/app.dart';
import 'package:fe/simple_bloc_observer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_config/flutter_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  Bloc.observer = SimpleBlocObserver();
  runApp(App(
    authenticationRepository: AuthenticationRepository(),
  ));
}

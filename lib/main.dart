import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:fe/app.dart';
import 'package:fe/simple_bloc_observer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as env;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await env.load(fileName: '.env');

  Bloc.observer = SimpleBlocObserver();
  runApp(App(
    authenticationRepository: AuthenticationRepository(),
  ));
}

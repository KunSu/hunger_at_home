import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fe/login/login.dart';
import 'package:flutter/material.dart';

import 'body.dart';

class LoginPage extends StatelessWidget {
  static String routeName = '/login';

  static Route route() {
    return MaterialPageRoute<LoginPage>(
      builder: (context) => BlocProvider.value(
        value: LoginFormBloc(
          authenticationRepository:
              RepositoryProvider.of<AuthenticationRepository>(context),
        ),
        child: LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Body(),
    );
  }
}

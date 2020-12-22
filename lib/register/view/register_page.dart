import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/company/company.dart';
import 'package:fe/register/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'body.dart';

class RegisterPage extends StatelessWidget {
  static String routeName = '/register';

  static Route route() {
    return MaterialPageRoute<RegisterPage>(
      builder: (context) => BlocProvider.value(
        value: RegisterBloc(
          authenticationRepository:
              RepositoryProvider.of<AuthenticationRepository>(context),
        ),
        child: RegisterPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CompanyIDArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Body(companyID: args.companyID),
    );
  }
}

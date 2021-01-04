import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/view/background.dart';
import 'package:fe/register/view/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class Body extends StatelessWidget {
  const Body({Key key, this.companyID}) : super(key: key);

  final String companyID;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Background(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/landing_logo.png',
                height: size.height * 0.05,
              ),
              Column(
                children: <Widget>[
                  const Text(
                    'Create Account',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'and start saving food',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          BlocProvider(
            create: (context) => RegisterFormBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context),
            ),
            child: RegisterForm(companyID: companyID),
          ),
        ],
      ),
    ));
  }
}

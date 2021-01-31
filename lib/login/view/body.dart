import 'package:fe/Login/view/login_form.dart';
import 'package:fe/components/view/background.dart';
import 'package:fe/login/bloc/loginfrom_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:authentication_repository/authentication_repository.dart';

class Body extends StatelessWidget {
  Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Background(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/food_logo.png',
                height: size.height * 0.3,
              ),
              SizedBox(height: size.height * 0.03),
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
                        'Welcome Back',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Login with your account',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.03),
              BlocProvider(
                create: (context) => LoginFormBloc(
                    authenticationRepository:
                        RepositoryProvider.of<AuthenticationRepository>(
                            context)),
                child: LoginForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

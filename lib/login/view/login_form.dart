import 'package:fe/login/bloc/loginfrom_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fe/login/login.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<LoginFormBloc>(context);
    return FormBlocListener<LoginFormBloc, String, String>(
      onSuccess: (context, state) {
        // Navigator.pushNamed(context, WelcomePage.routeName);
      },
      onFailure: (context, state) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(state.failureResponse),
          ),
        );
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFieldBlocBuilder(
                textFieldBloc: formBloc.email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(
                    Icons.email,
                  ),
                ),
              ),
              TextFieldBlocBuilder(
                textFieldBloc: formBloc.password,
                suffixButton: SuffixButton.obscureText,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(
                    Icons.lock,
                  ),
                ),
              ),
              RaisedButton(
                onPressed: formBloc.submit,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

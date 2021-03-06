import 'package:fe/register/bloc/registerform_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key key, this.companyID}) : super(key: key);
  final String companyID;

  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<RegisterFormBloc>(context);
    formBloc.companyID = companyID;

    return FormBlocListener<RegisterFormBloc, String, String>(
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
              TextFieldBlocBuilder(
                textFieldBloc: formBloc.firstName,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(
                    Icons.account_circle,
                  ),
                ),
              ),
              TextFieldBlocBuilder(
                textFieldBloc: formBloc.lastName,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(
                    Icons.account_circle,
                  ),
                ),
              ),
              TextFieldBlocBuilder(
                textFieldBloc: formBloc.phoneNumber,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(
                    Icons.local_phone,
                  ),
                ),
              ),
              DropdownFieldBlocBuilder(
                selectFieldBloc: formBloc.userIdentity,
                itemBuilder: (context, value) => value,
                decoration: const InputDecoration(
                    labelText: 'User Indentity',
                    prefixIcon: Icon(Icons.account_circle)),
              ),
              RaisedButton(
                onPressed: formBloc.submit,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

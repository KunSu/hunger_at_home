import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  LoginFormBloc({
    @required this.authenticationRepository,
  }) {
    addFieldBlocs(
      fieldBlocs: [
        email,
        password,
      ],
    );
  }

  final AuthenticationRepository authenticationRepository;
  final email = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.email,
    ],
  );
  final password = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  @override
  void onSubmitting() async {
    try {
      await authenticationRepository.logIn(
        email: email.value,
        password: password.value,
      );
      emitSuccess(
        canSubmitAgain: true,
      );
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }
  }
}

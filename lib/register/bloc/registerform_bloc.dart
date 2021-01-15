import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class RegisterFormBloc extends FormBloc<String, String> {
  RegisterFormBloc({
    @required this.authenticationRepository,
  }) {
    addFieldBlocs(
      fieldBlocs: [
        email,
        password,
        firstName,
        lastName,
        phoneNumber,
        userIdentity,
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
      FieldBlocValidators.passwordMin6Chars,
    ],
  );
  final firstName = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );
  final lastName = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );
  final phoneNumber = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final userIdentity = SelectFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
    items: [
      'Donor',
      'Recipient',
      'Employee',
      'Admin',
    ],
  );

  String companyID;

  @override
  void onSubmitting() async {
    try {
      await authenticationRepository.register(
        email: email.value,
        password: password.value,
        firstName: firstName.value,
        lastName: lastName.value,
        phoneNumber: phoneNumber.value,
        userIdentity: userIdentity.value,
        companyID: companyID,
      );
      emitSuccess(
        canSubmitAgain: true,
      );
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }
  }
}

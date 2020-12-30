import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      'Approver',
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

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key key, this.companyID}) : super(key: key);
  final String companyID;

  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<RegisterFormBloc>(context);
    formBloc.companyID = companyID;

    return FormBlocListener<RegisterFormBloc, String, String>(
      onSuccess: (context, state) {
        // context.bloc<RegisterBloc>().add(
        //       RegisterUserIdentityChanged(formBloc.userIdentity.value),
        //     );
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
                keyboardType: TextInputType.visiblePassword,
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

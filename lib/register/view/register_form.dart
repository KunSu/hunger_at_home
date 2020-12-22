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
  final email = TextFieldBloc();
  final password = TextFieldBloc();
  final firstName = TextFieldBloc();
  final lastName = TextFieldBloc();
  final phoneNumber = TextFieldBloc();
  final userIdentity = SelectFieldBloc(
    items: [
      'Donor',
      'Recipient',
      'Employee',
      'Approver',
    ],
  );

  @override
  void onSubmitting() async {
    try {
      authenticationRepository.register(
        email: email.value,
        password: password.value,
        firstname: firstName.value,
        lastname: lastName.value,
        phonenumber: phoneNumber.value,
        useridentity: userIdentity.value,
      );
      emitSuccess(
        canSubmitAgain: true,
      );
    } on Exception catch (_) {
      emitFailure();
    }
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key key, this.companyID}) : super(key: key);
  final String companyID;

  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<RegisterFormBloc>(context);

    return FormBlocListener<RegisterFormBloc, String, String>(
      onSuccess: (context, state) {
        // context.bloc<RegisterBloc>().add(
        //       RegisterUserIdentityChanged(formBloc.userIdentity.value),
        //     );
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

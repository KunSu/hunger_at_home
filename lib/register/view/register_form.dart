import 'package:fe/register/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TODO: UI
            _UsernameInput(),
            // const Padding(padding: EdgeInsets.all(12)),
            _PasswordInput(),
            // const Padding(padding: EdgeInsets.all(12)),
            _FirstnameInput(),
            // const Padding(padding: EdgeInsets.all(12)),
            _LastnameInput(),
            // const Padding(padding: EdgeInsets.all(12)),
            _PhoneNumberInput(),
            // const Padding(padding: EdgeInsets.all(12)),
            _UserIdentityInput(), // RoleDropDownButton(),
            // const Padding(padding: EdgeInsets.all(12)),
            _RegisterButton(),
          ],
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('RegisterForm_usernameInput_textField'),
          onChanged: (username) => context
              .bloc<RegisterBloc>()
              .add(RegisterUsernameChanged(username)),
          decoration: InputDecoration(
            labelText: 'username',
            errorText: state.username.invalid ? 'invalid username' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('RegisterForm_passwordInput_textField'),
          onChanged: (password) => context
              .bloc<RegisterBloc>()
              .add(RegisterPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password',
            errorText: state.password.invalid ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _FirstnameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('RegisterForm_firstnameInput_textField'),
          onChanged: (firstname) => context
              .bloc<RegisterBloc>()
              .add(RegisterFirstnameChanged(firstname)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'firstname',
            errorText: state.firstname.invalid ? 'invalid firstname' : null,
          ),
        );
      },
    );
  }
}

class _LastnameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('RegisterForm_lastnameInput_textField'),
          onChanged: (lastname) => context
              .bloc<RegisterBloc>()
              .add(RegisterLastnameChanged(lastname)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'lastname',
            errorText: state.lastname.invalid ? 'invalid lastname' : null,
          ),
        );
      },
    );
  }
}

class _PhoneNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('RegisterForm_phonenumberInput_textField'),
          onChanged: (phonenumber) => context
              .bloc<RegisterBloc>()
              .add(RegisterPhoneNumberChanged(phonenumber)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'phonenumber',
            errorText: state.phonenumber.invalid ? 'invalid phonenumber' : null,
          ),
        );
      },
    );
  }
}

class _UserIdentityInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('RegisterForm_useridentityInput_textField'),
          onChanged: (useridentity) => context
              .bloc<RegisterBloc>()
              .add(RegisterUserIdentityChanged(useridentity)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'useridentity',
            errorText:
                state.useridentity.invalid ? 'invalid useridentity' : null,
          ),
        );
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : RaisedButton(
                key: const Key('RegisterForm_continue_raisedButton'),
                child: const Text('Register'),
                onPressed: state.status.isValidated
                    ? () {
                        context
                            .bloc<RegisterBloc>()
                            .add(const RegisterSubmitted());
                      }
                    : null,
              );
      },
    );
  }
}

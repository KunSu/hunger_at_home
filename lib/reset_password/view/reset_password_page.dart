import 'package:fe/components/view/display_error.dart';
import 'package:fe/components/view/my_circularprogress_indicator.dart';
import 'package:fe/reset_password/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage();

  static String routeName = '/reset_password';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Reset Password')),
        body: Builder(
          builder: (context) {
            final formBloc = RepositoryProvider.of<ResetPasswordBloc>(context);
            return FormBlocListener<ResetPasswordBloc, String, String>(
              onSuccess: (context, state) {
                displayError(
                  context: context,
                  error: state.successResponse,
                );
              },
              onFailure: (context, state) {
                displayError(
                  context: context,
                  error: state.failureResponse,
                );
              },
              child: BlocBuilder<ResetPasswordBloc, FormBlocState>(
                builder: (context, state) {
                  if (state is FormBlocLoaded) {
                    return ReferenceView(formBloc: formBloc);
                  } else {
                    if (state is FormBlocFailure) {
                      formBloc.emitLoaded();
                    }
                    return const MyCircularProgressIndicator();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class ReferenceView extends StatelessWidget {
  const ReferenceView({
    Key key,
    @required this.formBloc,
  }) : super(key: key);

  final ResetPasswordBloc formBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          RaisedButton(
            onPressed: formBloc.submit,
            child: const Text('Reset Password'),
          ),
        ],
      ),
    );
  }
}

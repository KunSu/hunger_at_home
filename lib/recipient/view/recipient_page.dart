import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fe/authentication/authentication.dart';

class RecipientPage extends StatelessWidget {
  static String routeName = '/recipient';

  static Route route() {
    return MaterialPageRoute<RecipientPage>(
      builder: (context) => BlocProvider.value(
        value: BlocProvider.of<AuthenticationBloc>(context),
        child: RecipientPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipient')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'UserID: ${context.bloc<AuthenticationBloc>().state.user.id}',
            ),
            RaisedButton(
              child: const Text('Logout'),
              onPressed: () {
                context
                    .bloc<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested());
              },
            ),
          ],
        ),
      ),
    );
  }
}

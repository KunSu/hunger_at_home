import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fe/authentication/authentication.dart';

class HomePage extends StatelessWidget {
  static String routeName = '/home';

  static Route route() {
    return MaterialPageRoute<HomePage>(
      builder: (context) => BlocProvider.value(
        value: BlocProvider.of<AuthenticationBloc>(context),
        child: HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Please contact admin to verify your registration.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
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

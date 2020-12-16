import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fe/authentication/authentication.dart';

class ApproverPage extends StatelessWidget {
  static String routeName = '/approver';

  static Route route() {
    return MaterialPageRoute<ApproverPage>(
      builder: (context) => BlocProvider.value(
        value: BlocProvider.of<AuthenticationBloc>(context),
        child: ApproverPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Approver')),
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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fe/authentication/authentication.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(Icons.account_circle, size: size.height * 0.08),
        ),
        Container(
          width: size.width * 0.70,
          child: ListTile(
            title: Text(
              'Hi, ${context.bloc<AuthenticationBloc>().state.user.firstName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
                'Thanks for rescue surplus food, feed the needy, and have a positive effect on the environment.'),
          ),
        ),
      ],
    );
  }
}

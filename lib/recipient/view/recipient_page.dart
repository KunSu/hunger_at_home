import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/view/buttom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fe/authentication/authentication.dart';

import 'body.dart';

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
      appBar: AppBar(
        title: const Text('Recipient'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.of(context).pushNamed('/cart'),
          ),
        ],
      ),
      body: Body(),
      bottomNavigationBar: MyBottomNavigationBar(
        identity: RepositoryProvider.of<AuthenticationRepository>(context)
            .user
            .userIdentity,
      ),
    );
  }
}

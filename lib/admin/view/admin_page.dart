import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/view/buttom_navigation_bar_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fe/authentication/authentication.dart';

import 'body.dart';

class AdminPage extends StatelessWidget {
  static String routeName = '/admin';

  static Route route() {
    return MaterialPageRoute<AdminPage>(
      builder: (context) => BlocProvider.value(
        value: BlocProvider.of<AuthenticationBloc>(context),
        child: AdminPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
      ),
      body: Body(),
      bottomNavigationBar: MyBottomNavigationBarV2(
        identity: RepositoryProvider.of<AuthenticationRepository>(context)
            .user
            .userIdentity,
      ),
    );
  }
}

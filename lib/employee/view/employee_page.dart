import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/view/buttom_navigation_bar_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fe/authentication/authentication.dart';

import 'body.dart';

class EmployeePage extends StatelessWidget {
  static String routeName = '/employee';

  static Route route() {
    return MaterialPageRoute<EmployeePage>(
      builder: (context) => BlocProvider.value(
        value: BlocProvider.of<AuthenticationBloc>(context),
        child: EmployeePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee'),
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

import 'package:fe/order/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fe/authentication/authentication.dart';

import 'body.dart';

class DonorPage extends StatelessWidget {
  static String routeName = '/donor';

  static Route route() {
    return MaterialPageRoute<DonorPage>(
      builder: (context) => BlocProvider.value(
        value: BlocProvider.of<AuthenticationBloc>(context),
        child: DonorPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Donor')),
      // body: Body(),
      body: Body(),
    );
  }
}

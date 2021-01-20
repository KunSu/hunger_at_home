import 'package:flutter/material.dart';

import 'body.dart';

class PendingRegistrationPage extends StatelessWidget {
  const PendingRegistrationPage({Key key}) : super(key: key);

  static String routeName = '/pending_registraion';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Registration')),
      body: const Body(),
    );
  }
}

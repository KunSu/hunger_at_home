import 'package:flutter/material.dart';

import 'body.dart';

class AddressPage extends StatelessWidget {
  static String routeName = '/address';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Address')),
      body: Body(),
    );
  }
}

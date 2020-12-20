import 'package:flutter/material.dart';

import 'body.dart';

class CartPage extends StatelessWidget {
  static String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: const Body(),
    );
  }
}

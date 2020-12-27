import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({Key key, @required this.title}) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(title),
      floating: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () => Navigator.of(context).pushNamed('/cart'),
        ),
      ],
    );
  }
}

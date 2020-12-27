import 'package:fe/components/view/buttom_navigation_bar.dart';
import 'package:fe/donate/view/donate_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fe/authentication/authentication.dart';

import 'body.dart';

class DonorPage extends StatefulWidget {
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
  _DonorPageState createState() => _DonorPageState();
}

class _DonorPageState extends State<DonorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor'),
        // floating: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.of(context).pushNamed('/cart'),
          ),
        ],
      ),
      body: Body(),
      bottomNavigationBar: MyBottomNavigationBar(
        homeRouteName: DonorPage.routeName,
        itemRouteName: DonatePage.routeName,
      ),
    );
  }
}

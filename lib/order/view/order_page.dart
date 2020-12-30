import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/view/buttom_navigation_bar.dart';
import 'package:fe/components/view/order_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderPage extends StatelessWidget {
  static String routeName = '/order';

  static Route route() {
    return MaterialPageRoute<OrderPage>(
      builder: (context) => OrderPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: OrderList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        identity: RepositoryProvider.of<AuthenticationRepository>(context)
            .user
            .userIdentity,
      ),
    );
  }
}

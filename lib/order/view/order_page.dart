import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/view/buttom_navigation_bar.dart';
import 'package:fe/components/view/buttom_navigation_bar_v2.dart';
import 'package:fe/components/view/order_action_list.dart';
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
    final identity = RepositoryProvider.of<AuthenticationRepository>(context)
        .user
        .userIdentity;
    return Scaffold(
      appBar: AppBar(title: const Text('Order')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: OrderActionList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: identity == 'donor' || identity == 'recipient'
          ? MyBottomNavigationBar(
              identity: RepositoryProvider.of<AuthenticationRepository>(context)
                  .user
                  .userIdentity,
            )
          : MyBottomNavigationBarV2(
              identity: RepositoryProvider.of<AuthenticationRepository>(context)
                  .user
                  .userIdentity,
            ),
    );
  }
}

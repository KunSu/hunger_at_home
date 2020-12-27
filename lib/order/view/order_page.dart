import 'package:fe/components/view/buttom_navigation_bar.dart';
import 'package:fe/components/view/order_list.dart';
import 'package:fe/donate/view/donate_page.dart';
import 'package:fe/donor/donor.dart';
import 'package:flutter/material.dart';

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
        homeRouteName: DonorPage.routeName,
        itemRouteName: DonatePage.routeName,
      ),
    );
  }
}

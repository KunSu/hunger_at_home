import 'package:fe/components/view/order_card_list.dart';
import 'package:fe/components/view/user_info.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const UserInfo(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const Text('Upcoming pickup schedule'),
                  OrderCardList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

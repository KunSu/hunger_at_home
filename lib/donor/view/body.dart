import 'package:fe/components/view/order_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fe/authentication/authentication.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/Profile Image.png',
                  height: size.height * 0.1,
                ),
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Hi, ${context.bloc<AuthenticationBloc>().state.user.email}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: size.width * 0.7,
                    child: const Text(
                      'Thanks for rescue surplus food, feed the needy, and have a positive effect on the environment.',
                      // style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Upcoming pickup schedule'),
                // OrderList(),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: OrderList(),
            ),
          ),
        ],
      ),
    );
  }
}

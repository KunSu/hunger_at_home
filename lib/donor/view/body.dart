import 'package:fe/components/view/rounded_botton.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_detail/view/view.dart';
import 'package:fe/pantry/pantry.dart';
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
          // NagivatorHeader(),
          // SizedBox(height: getProportionateScreenHeight(10)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                // padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/Profile Image.png',
                  height: size.height * 0.1,
                ),
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Hi, ${context.bloc<AuthenticationBloc>().state.user.username}',
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
                const Text('My pantry'),
                // _OrderList(),
              ],
            ),
          ),

          RoundedButton(
            text: 'Pantry',
            press: () {
              Navigator.pushNamed(context, PantryPage.routeName);
            },
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: _OrderList(),
            ),
          ),
          RoundedButton(
            text: 'Orders',
            press: () {
              Navigator.pushNamed(context, OrderPage.routeName);
            },
          ),
        ],
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoadInProgress) {
          return const CircularProgressIndicator();
        }
        if (state is OrdersLoadSuccess) {
          if (state.orders.isEmpty) {
            return const Text('You do not have any order yet');
          }
          return ListView.builder(
            // scrollDirection: Axis.horizontal,
            itemCount: state.orders.length,
            itemBuilder: (context, index) =>
                _OrderView(order: state.orders[index]),
          );
        }
        return const Text('Something went wrong!');
      },
    );
  }
}

class _OrderView extends StatelessWidget {
  const _OrderView({Key key, this.order}) : super(key: key);

  final Order order;
  @override
  Widget build(BuildContext context) {
    // TODO: UI
    return ListTile(
      title: Text('name ${order.items[0].name}'),
      subtitle: Text(
          'Address: ${order.address} \nPick Up: ${order.pickupDateAndTime}'),
      trailing: Container(
        child: IconButton(
          icon: const Icon(
            Icons.arrow_right,
            size: 30,
          ),
          onPressed: () {
            Navigator.pushNamed(
              context,
              OrderDetailPage.routeName,
              arguments: ScreenArguments(order: order),
            );
          },
        ),
      ),
    );
  }
}

class ScreenArguments {
  ScreenArguments({this.order});

  final Order order;
}

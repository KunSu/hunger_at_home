import 'package:fe/authentication/authentication.dart';
import 'package:fe/donate/donate.dart';
import 'package:fe/donor/donor.dart';
import 'package:fe/order/bloc/orders_bloc.dart';
import 'package:fe/order/models/model.dart';
import 'package:fe/order/order.dart';
import 'package:fe/pantry/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fe/cart/cart.dart';

class CartPage extends StatelessWidget {
  static String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: _CartList(),
            ),
          ),
          const Divider(height: 4, color: Colors.black),
          // _CartTotal()
          BlocBuilder<CartBloc, CartState>(builder: (context, state) {
            if (state is CartLoaded) {
              return RaisedButton(
                onPressed: () {
                  var order = Order(
                    id: '1',
                    name: 'order 1',
                    items: state.cart.items,
                    userID: context.read<AuthenticationBloc>().state.user.id,
                    address: 'address',
                    pickupDateAndTime: 'pickupDateAndTime',
                    submitedDateAndTime: DateTime.now().toUtc().toString(),
                  );
                  context.read<OrdersBloc>().add(OrderAdded(order));
                  Navigator.pushNamed(context, OrderPage.routeName);
                },
                child: Text('Submit order'),
              );
            }
          }),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, DonatePage.routeName);
            },
            child: Text('Donate more items'),
          ),
        ],
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final itemNameStyle = Theme.of(context).textTheme.headline6;

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return const CircularProgressIndicator();
        }
        if (state is CartLoaded) {
          return ListView.builder(
            itemCount: state.cart.items.length,
            itemBuilder: (context, index) =>
                _ItemView(item: state.cart.items[index]),

            // ListTile(
            //   leading: const Icon(Icons.done),
            //   title: Text(
            //     state.cart.items[index].name,
            //     style: itemNameStyle,
            //   ),
            // ),
          );
        }
        return const Text('Something went wrong!');
      },
    );
  }
}

class _ItemView extends StatelessWidget {
  const _ItemView({Key key, this.item}) : super(key: key);

  final Item item;
  @override
  Widget build(BuildContext context) {
    // TODO: UI
    return Column(children: [
      Text(item.name),
      Text(item.quantityNumber + ' ' + item.quantityUnit),
    ]);
  }
}

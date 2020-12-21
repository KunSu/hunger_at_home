import 'package:fe/order/bloc/orders_bloc.dart';
import 'package:fe/order/models/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderPage extends StatelessWidget {
  static String routeName = '/order';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: _OrderList(),
            ),
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
          return ListView.builder(
            itemCount: state.orders.length,
            itemBuilder: (context, index) =>
                _OrderView(item: state.orders[index]),
          );
        }
        return const Text('Something went wrong!');
      },
    );
  }
}

class _OrderView extends StatelessWidget {
  const _OrderView({Key key, this.item}) : super(key: key);

  final Order item;
  @override
  Widget build(BuildContext context) {
    // TODO: UI
    return Column(children: [
      // Text(item.name),
      Text('userID ' + item.userID),
      Text('items ' + item.items[0].name),
      Text(item.address),
      Text(item.pickupDateAndTime),
      // Text(item.quantityNumber + ' ' + item.quantityUnit),
    ]);
  }
}

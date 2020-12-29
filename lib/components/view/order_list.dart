import 'package:fe/order/order.dart';
import 'package:fe/order_detail/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoadInProgress) {
          return const CircularProgressIndicator();
        }
        if (state is OrdersLoadSuccess) {
          if (state.orders == null || state.orders.isEmpty) {
            return const Text('You do not have any order yet');
          }
          return ListView.builder(
            itemCount: state.orders.length,
            itemBuilder: (context, index) =>
                OrderView(order: state.orders[index]),
          );
        }
        return const Text('Something went wrong!');
      },
    );
  }
}

class OrderView extends StatelessWidget {
  const OrderView({Key key, this.order}) : super(key: key);

  final Order order;
  @override
  Widget build(BuildContext context) {
    // TODO: UI
    return ListTile(
      title: Text('Order #: ${order.id}'),
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

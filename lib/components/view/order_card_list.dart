import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_delivery/view/order_delivery_page.dart';
import 'package:fe/order_detail/view/order_detail_page.dart';
import 'package:fe/order_pickup/view/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'order_list.dart';

class OrderCardList extends StatelessWidget {
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
                OrderCardView(order: state.orders[index]),
          );
        }
        return const Text('Something went wrong!');
      },
    );
  }
}

class OrderCardView extends StatelessWidget {
  const OrderCardView({Key key, this.order}) : super(key: key);
  final Order order;
  @override
  Widget build(BuildContext context) {
    final identity = RepositoryProvider.of<AuthenticationRepository>(context)
        .user
        .userIdentity;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            // leading: const Icon(Icons.album),
            title: Text('Order #: ${order.id}'),
            subtitle: RichText(
              text: TextSpan(
                text: 'Pick up date: ${order.pickupDateAndTime}\n',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Address: ${order.address}\n',
                  ),
                  TextSpan(
                    text: 'status: ${order.status}\n',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                      // fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text('Detail'),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    OrderDetailPage.routeName,
                    arguments: ScreenArguments(order: order),
                  );
                },
              ),
              TextButton(
                child: const Text('Contact'),
                onPressed: () {/* ... */},
              ),
              Visibility(
                visible: order.status == 'approved' && identity == 'employee',
                child: TextButton(
                  child: const Text('Pick up'),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      OrderPickupPage.routeName,
                      arguments: ScreenArguments(order: order),
                    );
                    // var newOrder = order.copyWith(status: 'pickup');
                    // BlocProvider.of<OrdersBloc>(context)
                    //     .add(OrderUpdated(newOrder));
                  },
                ),
              ),
              Visibility(
                visible: order.status == 'received' && identity == 'employee',
                child: TextButton(
                  child: const Text('Deliver'),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      OrderDeliveryPage.routeName,
                      arguments: ScreenArguments(order: order),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_detail/view/order_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'order_list.dart';

class OrderActionList extends StatelessWidget {
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
                OrderActionView(order: state.orders[index]),
          );
        }
        return const Text('Something went wrong!');
      },
    );
  }
}

class OrderActionView extends StatelessWidget {
  const OrderActionView({Key key, this.order}) : super(key: key);
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
            leading: const Icon(Icons.album),
            title: Text('Order #: ${order.id}'),
            subtitle: RichText(
              text: TextSpan(
                text: 'Order date: ${order.submitedDateAndTime}\n',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Order date: ${order.submitedDateAndTime}\n',
                  ),
                  TextSpan(
                    text: 'Pick up date: ${order.pickupDateAndTime}\n',
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
                visible: order.status == 'pending',
                child: TextButton(
                  child: const Text('Approve'),
                  onPressed: () {
                    var newOrder = order.copyWith(status: 'on-going');
                    BlocProvider.of<OrdersBloc>(context)
                        .add(OrderUpdated(newOrder));
                  },
                ),
              ),
              Visibility(
                visible: order.status == 'pending',
                child: TextButton(
                  child: const Text('Withdraw'),
                  onPressed: () {
                    // TODO
                    /* ... */
                    // newOrder = order.copyWith(status: )
                  },
                ),
              ),
              Visibility(
                visible: order.status == 'approved' && identity == 'recipient',
                child: TextButton(
                  child: const Text('Recived'),
                  onPressed: () {},
                ),
              ),
              Visibility(
                visible: order.status == 'approved' && identity == 'employee',
                child: TextButton(
                  child: const Text('Pick up'),
                  onPressed: () {/* ... */},
                ),
              ),
              Visibility(
                visible: order.status == 'received' && identity == 'employee',
                child: TextButton(
                  child: const Text('Delivered'),
                  onPressed: () {/* ... */},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

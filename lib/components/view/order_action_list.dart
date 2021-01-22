import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/admin_order/view/admin_order_page.dart';
import 'package:fe/components/models/screen_arguments.dart';
import 'package:fe/components/ult/status_color.dart';
import 'package:fe/components/view/contact_dialog.dart';
import 'package:fe/components/view/dialog/order_update_dialog.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_delivery/view/order_delivery_page.dart';
import 'package:fe/order_detail/view/order_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class OrderActionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state is OrdersLoadFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
            ),
          );
        }
      },
      child: BlocBuilder<OrdersBloc, OrdersState>(
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
          if (state is OrdersLoadFailure) {
            return FutureBuilder<List<Order>>(
              future: RepositoryProvider.of<OrdersRepository>(context).reload(
                user: RepositoryProvider.of<AuthenticationRepository>(context)
                    .user,
                status: ' ',
              ),
              builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) =>
                        AdminOrderActionView(order: snapshot.data[index]),
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error);
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          }
          return const Text('Something went wrong');
        },
      ),
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
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Order date: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '${order.submitedDateAndTime}\n',
                  ),
                  const TextSpan(
                    text: 'Address: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '${order.address}\n',
                  ),
                  const TextSpan(
                    text: 'Pick up date: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '${order.pickupDateAndTime}\n',
                  ),
                  const TextSpan(
                    text: 'Status: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '${order.status}\n',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: getStatusColor(status: order.status),
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
                onPressed: () {
                  contactDialog(
                    context: context,
                    order: order,
                  );
                },
              ),
              Visibility(
                visible: order.status == 'pending',
                child: TextButton(
                  child: const Text('Withdraw'),
                  onPressed: () {
                    orderUpdateDialog(
                        context: context,
                        order: order,
                        text:
                            'Please confirm if you want to withdraw the order.',
                        title: 'Confirmation',
                        status: 'withdraw');
                  },
                ),
              ),
              Visibility(
                visible: order.status == 'approved' &&
                    (identity == 'employee' || identity == 'admin'),
                child: TextButton(
                  child: const Text('Pick up'),
                  onPressed: () {
                    if (identity == 'admin') {
                      orderUpdateDialog(
                          context: context,
                          order: order,
                          text:
                              'Please confirm if you have picked up the order.',
                          title: 'Confirmation',
                          status: 'pickedup');
                    } else {
                      Navigator.pushNamed(
                        context,
                        OrderDeliveryPage.routeName,
                        arguments: ScreenArguments(order: order),
                      );
                    }
                  },
                ),
              ),
              Visibility(
                visible: order.status == 'pickedup' &&
                    (identity == 'employee' || identity == 'admin'),
                child: TextButton(
                  child: const Text('Deliver'),
                  onPressed: () {
                    if (identity == 'admin') {
                      orderUpdateDialog(
                          context: context,
                          order: order,
                          text:
                              'Please confirm if you have delivered the order.',
                          title: 'Confirmation',
                          status: 'delivered');
                    } else {
                      Navigator.pushNamed(
                        context,
                        OrderDeliveryPage.routeName,
                        arguments: ScreenArguments(order: order),
                      );
                    }
                  },
                ),
              ),
              // Visibility(
              //   visible: order.status == 'approved' &&
              //       (identity == 'recipient' || identity == 'admin'),
              //   child: TextButton(
              //     child: const Text('Receive'),
              //     onPressed: () {
              //       orderUpdateDialog(
              //           context: context,
              //           order: order,
              //           text: 'Please confirm if you have received the order.',
              //           title: 'Confirmation',
              //           status: 'received');
              //     },
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

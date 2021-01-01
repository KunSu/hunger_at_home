import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/models/screen_arguments.dart';
import 'package:fe/components/view/contact_dialog.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_detail/view/order_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

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
                onPressed: () {
                  ContactDialog(
                    context: context,
                    order: order,
                  );
                },
              ),
              Visibility(
                visible: order.status == 'pending',
                child: TextButton(
                  child: const Text('Approve'),
                  onPressed: () {
                    var newOrder = order.copyWith(status: 'approved');
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
                  onPressed: () {
                    _showMyDialog(context, order);
                  },
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

Future<void> _showMyDialog(context, order) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmation'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              const Text('Please confirm if you have received the order.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              var newOrder = order.copyWith(status: 'received');
              BlocProvider.of<OrdersBloc>(context).add(OrderUpdated(newOrder));
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

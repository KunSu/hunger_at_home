import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/models/screen_arguments.dart';
import 'package:fe/components/view/contact_dialog.dart';
import 'package:fe/components/view/dialog/order_update_dialog.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_assign/view/order_assign_page.dart';
import 'package:fe/order_delivery/view/order_delivery_page.dart';
import 'package:fe/order_detail/view/order_detail_page.dart';
import 'package:fe/order_edit/view/order_edit_page.dart';
import 'package:fe/order_pickup/view/order_pickup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderAction extends StatefulWidget {
  const OrderAction({
    Key key,
    @required this.order,
  }) : super(key: key);

  final Order order;

  @override
  _OrderActionState createState() => _OrderActionState();
}

class _OrderActionState extends State<OrderAction> {
  @override
  Widget build(BuildContext context) {
    final identity = RepositoryProvider.of<AuthenticationRepository>(context)
        .user
        .userIdentity;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          child: const Text('Detail'),
          onPressed: () {
            Navigator.pushNamed(
              context,
              OrderDetailPage.routeName,
              arguments: ScreenArguments(order: widget.order),
            );
          },
        ),
        TextButton(
          child: const Text('Contact'),
          onPressed: () {
            contactDialog(
              context: context,
              order: widget.order,
            );
          },
        ),
        Visibility(
          visible: getOrderActionVisibility(
            action: 'Edit',
            identity: identity,
            status: widget.order.status,
            orderType: widget.order.type,
          ),
          child: TextButton(
            child: const Text('Edit'),
            onPressed: () {
              Navigator.pushNamed(
                context,
                OrderEditPage.routeName,
                arguments: ScreenArguments(order: widget.order),
              );
            },
          ),
        ),
        Visibility(
          visible: getOrderActionVisibility(
            action: 'Cancel',
            identity: identity,
            status: widget.order.status,
            orderType: widget.order.type,
          ),
          child: TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              orderUpdateDialog(
                  context: context,
                  order: widget.order,
                  text: 'Please confirm if you have cancel this order.',
                  title: 'Confirmation',
                  status: 'cancelled');
            },
          ),
        ),
        Visibility(
          visible: getOrderActionVisibility(
            action: 'Approve',
            identity: identity,
            status: widget.order.status,
            orderType: widget.order.type,
          ),
          child: TextButton(
            child: const Text('Approve'),
            onPressed: () {
              if (widget.order.type == 'donation') {
                Navigator.pushNamed(
                  context,
                  OrderAssignPage.routeName,
                  arguments: ScreenArguments(order: widget.order),
                );
              } else if (widget.order.type == 'dropoff') {
                Navigator.pushNamed(
                  context,
                  OrderEditPage.routeName,
                  arguments: ScreenArguments(
                    order: widget.order,
                    screenTitle: 'Approve order',
                  ),
                );
              } else if (widget.order.type == 'request') {
                Navigator.pushNamed(
                  context,
                  OrderEditPage.routeName,
                  arguments: ScreenArguments(
                    order: widget.order,
                    screenTitle: 'Approve order',
                  ),
                );
              }
            },
          ),
        ),
        Visibility(
          visible: getOrderActionVisibility(
            action: 'Withdraw',
            identity: identity,
            status: widget.order.status,
            orderType: widget.order.type,
          ),
          child: TextButton(
            child: const Text('Withdraw'),
            onPressed: () {
              orderUpdateDialog(
                  context: context,
                  order: widget.order,
                  text: 'Please confirm if you want to withdraw the order.',
                  title: 'Confirmation',
                  status: 'withdraw');
            },
          ),
        ),
        Visibility(
          visible: getOrderActionVisibility(
            action: 'Confirm',
            identity: identity,
            status: widget.order.status,
            orderType: widget.order.type,
          ),
          child: TextButton(
            child: const Text('Confirm'),
            onPressed: () {
              orderUpdateDialog(
                  context: context,
                  order: widget.order,
                  text:
                      'Please confirm if you want to proceed with this order.',
                  title: 'Confirmation',
                  status: 'confirmed');
            },
          ),
        ),
        Visibility(
          visible: getOrderActionVisibility(
            action: 'Receive',
            identity: identity,
            status: widget.order.status,
            orderType: widget.order.type,
          ),
          child: TextButton(
            child: const Text('Receive'),
            onPressed: () {
              orderUpdateDialog(
                  context: context,
                  order: widget.order,
                  text: 'Please confirm if you have received the order.',
                  title: 'Confirmation',
                  status: 'received');
            },
          ),
        ),
        Visibility(
          visible: getOrderActionVisibility(
            action: 'Pick up',
            identity: identity,
            status: widget.order.status,
            orderType: widget.order.type,
          ),
          child: TextButton(
            child: const Text('Pick up'),
            onPressed: () {
              if (identity == 'admin') {
                orderUpdateDialog(
                    context: context,
                    order: widget.order,
                    text: 'Please confirm if you have picked up the order.',
                    title: 'Confirmation',
                    status: 'pickedup');
              } else {
                Navigator.pushNamed(
                  context,
                  OrderPickupPage.routeName,
                  arguments: ScreenArguments(order: widget.order),
                );
              }
            },
          ),
        ),
        Visibility(
          visible: getOrderActionVisibility(
            action: 'Drop off',
            identity: identity,
            status: widget.order.status,
            orderType: widget.order.type,
          ),
          child: TextButton(
            child: const Text('Drop off'),
            onPressed: () {
              if (identity == 'admin') {
                orderUpdateDialog(
                    context: context,
                    order: widget.order,
                    text:
                        'Please confirm if you have received the drop off order.',
                    title: 'Confirmation',
                    status: 'droppedoff');
              }
            },
          ),
        ),
        Visibility(
          visible: getOrderActionVisibility(
            action: 'Deliver',
            identity: identity,
            status: widget.order.status,
            orderType: widget.order.type,
          ),
          child: TextButton(
            child: const Text('Deliver'),
            onPressed: () {
              if (identity == 'admin') {
                orderUpdateDialog(
                    context: context,
                    order: widget.order,
                    text: 'Please confirm if you have delivered the order.',
                    title: 'Confirmation',
                    status: 'delivered');
              } else {
                Navigator.pushNamed(
                  context,
                  OrderDeliveryPage.routeName,
                  arguments: ScreenArguments(order: widget.order),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

bool getOrderActionVisibility({
  @required String identity,
  @required String status,
  @required String action,
  String orderType,
}) {
  switch (action) {
    case 'Edit':
      if (identity == 'admin' &&
          (status == 'approved' ||
              status == 'confirmed' ||
              status == 'pickedup')) return true;
      break;
    case 'Approve':
      if (identity == 'admin' && status == 'pending') return true;
      break;
    case 'Confirm':
      if ((identity == 'donor' || identity == 'recipient') &&
          status == 'approved') return true;
      break;
    case 'Pick up':
      if (orderType == 'donation' &&
          (identity == 'admin' || identity == 'employee') &&
          status == 'confirmed') return true;
      break;
    case 'Deliver':
      if (orderType == 'donation' &&
          (identity == 'admin' || identity == 'employee') &&
          status == 'pickedup') return true;
      break;
    case 'Drop off':
      if (orderType == 'dropoff' &&
          (identity == 'admin' || identity == 'employee') &&
          status == 'confirmed') return true;
      break;
    case 'Receive':
      if ((orderType == 'request' || orderType == 'anonymous') &&
          identity == 'admin' &&
          status == 'confirmed') return true;
      break;
    case 'Withdraw':
      if ((identity == 'donor' || identity == 'recipient') &&
          (status == 'pending' || status == 'approved')) return true;
      break;
    case 'Cancel':
      if (identity == 'admin' &&
          (status == 'pending' ||
              status == 'approved' ||
              status == 'confirmed' ||
              status == 'pickedup')) return true;
      break;
    case 'Archive':
      if (status == 'droppedoff' ||
          status == 'delivered' ||
          status == 'received') return true;
      break;
    case 'Delete':
      if (status == 'withdraw' || status == 'canceled') return true;
      break;
    default:
      break;
  }
  return false;
}

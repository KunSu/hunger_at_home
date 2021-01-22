import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/models/screen_arguments.dart';
import 'package:fe/components/ult/status_color.dart';
import 'package:fe/components/view/contact_dialog.dart';
import 'package:fe/components/view/dialog/order_update_dialog.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_assign/view/order_assign_page.dart';
import 'package:fe/order_delivery/view/order_delivery_page.dart';
import 'package:fe/order_detail/view/order_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminOrderActionView extends StatefulWidget {
  const AdminOrderActionView({Key key, this.order}) : super(key: key);
  final Order order;

  @override
  _AdminOrderActionViewState createState() => _AdminOrderActionViewState();
}

class _AdminOrderActionViewState extends State<AdminOrderActionView> {
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
            title: Text('Order #: ${widget.order.id}'),
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
                    text: '${widget.order.submitedDateAndTime}\n',
                  ),
                  const TextSpan(
                    text: 'Address: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '${widget.order.address}\n',
                  ),
                  const TextSpan(
                    text: 'Pick up date: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '${widget.order.pickupDateAndTime}\n',
                  ),
                  const TextSpan(
                    text: 'Status: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '${widget.order.status}\n',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: getStatusColor(status: widget.order.status),
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
              // Visibility(
              //   visible: identity == 'admin',
              //   child: TextButton(
              //     child: const Text('Edit'),
              //     onPressed: () {
              //       Navigator.pushNamed(
              //         context,
              //         OrderEditPage.routeName,
              //         arguments: ScreenArguments(order: widget.order),
              //       );
              //     },
              //   ),
              // ),
              Visibility(
                visible:
                    widget.order.status == 'pending' && identity == 'admin',
                child: TextButton(
                  child: const Text('Approve'),
                  onPressed: () {
                    if (widget.order.type == 'donation') {
                      Navigator.pushNamed(
                        context,
                        OrderAssignPage.routeName,
                        arguments: ScreenArguments(order: widget.order),
                      );
                    } else {
                      orderUpdateDialog(
                          context: context,
                          order: widget.order,
                          text:
                              'Please confirm if you want to approve the order.',
                          title: 'Confirmation',
                          status: 'approved');
                    }
                  },
                ),
              ),
              Visibility(
                visible: widget.order.status == 'pending',
                child: TextButton(
                  child: const Text('Withdraw'),
                  onPressed: () {
                    orderUpdateDialog(
                        context: context,
                        order: widget.order,
                        text:
                            'Please confirm if you want to withdraw the order.',
                        title: 'Confirmation',
                        status: 'withdraw');
                  },
                ),
              ),
              Visibility(
                visible: widget.order.status == 'approved' &&
                    widget.order.type != 'dropoff' &&
                    (identity == 'recipient' || identity == 'admin'),
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
                visible: widget.order.status == 'approved' &&
                    widget.order.type != 'dropoff' &&
                    (identity == 'employee' || identity == 'admin'),
                child: TextButton(
                  child: const Text('Pick up'),
                  onPressed: () {
                    if (identity == 'admin') {
                      orderUpdateDialog(
                          context: context,
                          order: widget.order,
                          text:
                              'Please confirm if you have picked up the order.',
                          title: 'Confirmation',
                          status: 'pickedup');
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
              Visibility(
                visible: widget.order.status == 'approved' &&
                    widget.order.type == 'dropoff' &&
                    (identity == 'employee' || identity == 'admin'),
                child: TextButton(
                  child: const Text('Droped off'),
                  onPressed: () {
                    if (identity == 'admin') {
                      orderUpdateDialog(
                          context: context,
                          order: widget.order,
                          text:
                              'Please confirm if you have received the drop off order.',
                          title: 'Confirmation',
                          status: 'droppedoff');
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
              Visibility(
                visible: widget.order.status == 'pickedup' &&
                    (identity == 'employee' || identity == 'admin'),
                child: TextButton(
                  child: const Text('Deliver'),
                  onPressed: () {
                    if (identity == 'admin') {
                      orderUpdateDialog(
                          context: context,
                          order: widget.order,
                          text:
                              'Please confirm if you have delivered the order.',
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
          ),
        ],
      ),
    );
  }
}

import 'package:fe/components/ult/status_color.dart';
import 'package:fe/components/view/order/order_action.dart';
import 'package:fe/order/order.dart';
import 'package:flutter/material.dart';

class AdminOrderActionView extends StatefulWidget {
  const AdminOrderActionView({Key key, this.order}) : super(key: key);
  final Order order;

  @override
  _AdminOrderActionViewState createState() => _AdminOrderActionViewState();
}

class _AdminOrderActionViewState extends State<AdminOrderActionView> {
  @override
  Widget build(BuildContext context) {
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
                    text: 'Order Name: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        '${widget.order.name != null ? widget.order.name : "N/A"}\n',
                  ),
                  const TextSpan(
                    text: 'Order Type: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '${widget.order.type}\n',
                  ),
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
          OrderAction(
            order: widget.order,
          ),
        ],
      ),
    );
  }
}

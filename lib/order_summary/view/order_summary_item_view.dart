import 'package:fe/components/ult/status_color.dart';
import 'package:fe/order/order.dart';
import 'package:flutter/material.dart';

class OrderSummaryItemView extends StatelessWidget {
  const OrderSummaryItemView({Key key, this.order}) : super(key: key);

  final Order order;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Order #: ${order.id}'),
      subtitle: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            const TextSpan(
              text: 'type: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: '${order.type}\n',
            ),
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
            TextSpan(
              text: 'Items count: ${order.items.length}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      children: order.items.map<Widget>(orderSummaryItemDetail).toList(),
    );
  }

  Widget orderSummaryItemDetail(Item item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
                '${item.name} ${item.quantityNumber} ${item.quantityUnit}'),
            subtitle: Text(item.category),
          ),
        ],
      ),
    );
  }
}

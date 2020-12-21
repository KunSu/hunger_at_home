import 'package:fe/donor/view/body.dart';
import 'package:fe/order/models/model.dart';
import 'package:fe/pantry/models/models.dart';
import 'package:flutter/material.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({Key key}) : super(key: key);

  static String routeName = '/order_detail';

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    final order = args.order;

    return Scaffold(
      appBar: AppBar(title: const Text('Order details')),
      body: Column(
        children: [
          Text('ID: ${order.id}'),
          Text('Address: ${order.address}'),
          Text('Pick Up: ${order.pickupDateAndTime}'),
          // Text('State: ${order.state}'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: _ItemList(order: order),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemList extends StatelessWidget {
  const _ItemList({Key key, this.order}) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: order.items.length,
      itemBuilder: (context, index) => _ItemView(item: order.items[index]),
    );
  }
}

class _ItemView extends StatelessWidget {
  const _ItemView({Key key, this.item}) : super(key: key);

  final Item item;
  @override
  Widget build(BuildContext context) {
    // TODO: UI
    return ListTile(
      title: Text('${item.name}'),
      subtitle: Text('Quantity: ${item.quantityNumber} ${item.quantityUnit}'),
    );
  }
}

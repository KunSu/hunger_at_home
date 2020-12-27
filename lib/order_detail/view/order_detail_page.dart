import 'package:fe/components/view/order_list.dart';
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
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Company'),
                  subtitle: Text('${order.company}'),
                ),
                ListTile(
                  title: const Text('Pick Up Date'),
                  subtitle: Text('${order.pickupDateAndTime}'),
                ),
                ListTile(
                  title: const Text('Contact Number'),
                  subtitle: Text('${order.phoneNumber}'),
                ),
                ListTile(
                  title: const Text('Address: '),
                  subtitle: Text('${order.address}, ${order.state}'),
                ),
                // ListTile(
                //   title: const Text('Company: '),
                //   subtitle: Text('${order.company}'),
                // ),
                // Text(': '),
                // Text(': ${order.phoneNumber}'),
              ],
            ),
          ),

          // Text('State: ${order.state}'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
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
      subtitle: Text('${item.quantityNumber} ${item.quantityUnit}'),
    );
  }
}

import 'package:fe/order/models/model.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_detail/order_detail.dart';
import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  const ItemList({Key key, this.order}) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Item>>(
      future: OrderDetailRepository().loadOrderItems(
        // userID:
        //     RepositoryProvider.of<AuthenticationRepository>(context).user.id,
        orderID: order.id,
      ),
      builder: (context, AsyncSnapshot<List<Item>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) =>
                ItemView(item: snapshot.data[index]),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class ItemView extends StatelessWidget {
  const ItemView({Key key, this.item}) : super(key: key);

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

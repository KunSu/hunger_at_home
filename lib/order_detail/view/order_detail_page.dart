import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/models/screen_arguments.dart';
import 'package:fe/order/models/model.dart';
import 'package:fe/order_detail/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({Key key}) : super(key: key);

  static String routeName = '/order_detail';

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    final order = args.order;
    return Scaffold(
      appBar: AppBar(title: const Text('Order details')),
      body: FutureBuilder<OrderDetail>(
        future: OrderDetailRepository().loadOrderDetail(
          userID:
              RepositoryProvider.of<AuthenticationRepository>(context).user.id,
          orderID: order.id,
        ),
        builder: (context, AsyncSnapshot<OrderDetail> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Company'),
                        subtitle: Text('${snapshot.data.companyName}'),
                      ),
                      Visibility(
                        visible: snapshot.data.orderType != 'dropoff',
                        child: ListTile(
                          title: const Text('Pick Up Date'),
                          subtitle: Text('${snapshot.data.pickupTime}'),
                        ),
                      ),
                      Visibility(
                        visible: snapshot.data.orderType == 'dropoff',
                        child: const ListTile(
                          title: Text('Drop off order'),
                        ),
                      ),
                      ListTile(
                        title: const Text('Contact Number'),
                        subtitle: FlatButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => url_launcher
                              .launch('tel:+${snapshot.data.phoneNumber}'),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${snapshot.data.phoneNumber}',
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text('Address: '),
                        subtitle: FlatButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                '${snapshot.data.address}, ${snapshot.data.city}, ${snapshot.data.state} ${snapshot.data.zipCode}'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      const BoxShadow(color: Colors.grey, spreadRadius: 1),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    // padding: const EdgeInsets.all(8.0),
                    // height: 10.0,
                    margin: const EdgeInsets.all(8.0),
                    child: _ItemList(order: order),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        const BoxShadow(color: Colors.grey, spreadRadius: 1),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class _ItemList extends StatelessWidget {
  const _ItemList({Key key, this.order}) : super(key: key);
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
                  _ItemView(item: snapshot.data[index]),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
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

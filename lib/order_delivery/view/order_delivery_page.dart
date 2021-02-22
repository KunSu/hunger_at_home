import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/view/item_list.dart';
import 'package:fe/components/view/order_info.dart';
import 'package:fe/components/models/screen_arguments.dart';
import 'package:fe/order/models/model.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_delivery/order_delivery.dart';
import 'package:fe/order_detail/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class OrderDeliveryPage extends StatelessWidget {
  const OrderDeliveryPage({Key key}) : super(key: key);

  static String routeName = '/order_delivery';

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    final order = args.order;
    return Scaffold(
      appBar: AppBar(title: const Text('Order Delivery')),
      body: FutureBuilder<OrderDetail>(
        future: OrderDetailRepository().loadOrderDetail(
          userID:
              RepositoryProvider.of<AuthenticationRepository>(context).user.id,
          orderID: order.id,
        ),
        builder: (context, AsyncSnapshot<OrderDetail> snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OrderInfo(
                  order: order,
                  snapshot: snapshot,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    child: ItemList(order: order),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        const BoxShadow(color: Colors.grey, spreadRadius: 1),
                      ],
                    ),
                  ),
                ),
                BlocProvider(
                  create: (context) => OrderDeliveryBloc(
                      authenticationRepository:
                          RepositoryProvider.of<AuthenticationRepository>(
                              context),
                      ordersRepository:
                          RepositoryProvider.of<OrdersRepository>(context)),
                  child: _OrderDeliveryCheck(
                    order: order,
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

class _OrderDeliveryCheck extends StatelessWidget {
  const _OrderDeliveryCheck({
    Key key,
    this.order,
  }) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<OrderDeliveryBloc>(context);
    formBloc.order = order;
    return FormBlocListener<OrderDeliveryBloc, String, String>(
      onSuccess: (context, state) {
        BlocProvider.of<OrdersBloc>(context).add(OrderChanged(formBloc.order));
        Navigator.pushNamed(context, OrderPage.routeName);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TimeFieldBlocBuilder(
              timeFieldBloc: formBloc.time,
              format: DateFormat('hh:mm a'),
              initialTime: TimeOfDay.fromDateTime(
                  DateTime.now().add(const Duration(minutes: 30))),
              decoration: const InputDecoration(
                labelText: 'Delivery time',
                prefixIcon: Icon(Icons.access_time),
              ),
            ),
            TextFieldBlocBuilder(
              textFieldBloc: formBloc.temperature,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Temperature',
                prefixIcon: Icon(
                  Icons.ac_unit,
                ),
              ),
            ),
            RaisedButton(
              onPressed: formBloc.submit,
              child: const Text('Delivered'),
            ),
          ],
        ),
      ),
    );
  }
}

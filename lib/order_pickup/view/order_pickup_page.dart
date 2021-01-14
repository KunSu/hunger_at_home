import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/models/screen_arguments.dart';
import 'package:fe/components/view/item_list.dart';
import 'package:fe/components/view/order_info.dart';
import 'package:fe/order/models/model.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_detail/order_detail.dart';
import 'package:fe/order_pickup/bloc/order_pickup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class OrderPickupPage extends StatelessWidget {
  const OrderPickupPage({Key key}) : super(key: key);

  static String routeName = '/order_pickup';

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    final order = args.order;
    return Scaffold(
      appBar: AppBar(title: const Text('Order Pick Up')),
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
                  create: (context) => OrderPickupBloc(
                      authenticationRepository:
                          RepositoryProvider.of<AuthenticationRepository>(
                              context),
                      ordersRepository:
                          RepositoryProvider.of<OrdersRepository>(context)),
                  child: _OrderPickupCheck(
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

class _OrderPickupCheck extends StatelessWidget {
  const _OrderPickupCheck({
    Key key,
    this.order,
  }) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<OrderPickupBloc>(context);
    return FormBlocListener<OrderPickupBloc, String, String>(
      onSuccess: (context, state) {
        var newOrder = order.copyWith(
            userID: RepositoryProvider.of<AuthenticationRepository>(context)
                .user
                .id,
            status: 'pickedup');

        BlocProvider.of<OrdersBloc>(context).add(OrderUpdated(newOrder));
        Navigator.pushNamed(context, OrderPage.routeName);
      },
      child: Container(
        child: Column(
          children: [
            CheckboxFieldBlocBuilder(
              booleanFieldBloc: formBloc.foodNameCheck,
              body: Container(
                alignment: Alignment.centerLeft,
                child: const Text('Food Name Check'),
              ),
            ),
            CheckboxFieldBlocBuilder(
              booleanFieldBloc: formBloc.quantityCheck,
              body: Container(
                alignment: Alignment.centerLeft,
                child: const Text('Quantity Check'),
              ),
            ),
            CheckboxFieldBlocBuilder(
              booleanFieldBloc: formBloc.expirationCheck,
              body: Container(
                alignment: Alignment.centerLeft,
                child: const Text('Expiration Check'),
              ),
            ),
            RaisedButton(
              onPressed: formBloc.submit,
              child: const Text('Pick Up'),
            ),
          ],
        ),
      ),
    );
  }
}

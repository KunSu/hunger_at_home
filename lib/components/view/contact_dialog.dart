import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/view/order/order_info.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_detail/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> contactDialog({
  @required BuildContext context,
  @required Order order,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Contact Information'),
        content: SingleChildScrollView(
          child: FutureBuilder<OrderDetail>(
            future: OrderDetailRepository().loadOrderDetail(
              userID: RepositoryProvider.of<AuthenticationRepository>(context)
                  .user
                  .id,
              orderID: order.id,
            ),
            builder: (context, AsyncSnapshot<OrderDetail> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    OrderInfoView(order: order),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Back'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

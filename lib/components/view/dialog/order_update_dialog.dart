import 'package:fe/order/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> orderUpdateDialog({
  @required BuildContext context,
  @required Order order,
  @required String title,
  @required String text,
  @required String status,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(text),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              var newOrder = order.copyWith(status: status);
              Navigator.of(context).pop();
              BlocProvider.of<OrdersBloc>(context).add(OrderUpdated(newOrder));
            },
          ),
        ],
      );
    },
  );
}

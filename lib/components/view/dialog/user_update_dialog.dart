import 'package:fe/pending_registraion/pending_registraion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> userUpdateDialog({
  @required BuildContext context,
  @required String title,
  @required String text,
  @required String userID,
  @required String email,
  @required String status,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
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
              Navigator.of(context).pop();
              BlocProvider.of<EmployeesBloc>(context).add(EmployeesUpdated(
                userID: userID,
                email: email,
                status: status,
              ));
            },
          ),
        ],
      );
    },
  );
}

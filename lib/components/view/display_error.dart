import 'package:flutter/material.dart';

void displayError({
  @required BuildContext context,
  @required String error,
}) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(error),
    ),
  );
}

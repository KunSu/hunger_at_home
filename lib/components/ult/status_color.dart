import 'package:flutter/material.dart';

Color getStatusColor({String status}) {
  switch (status) {
    case 'delivered':
      return Colors.green;
      break;
    case 'picked up':
      return Colors.lightGreen;
      break;
    case 'pending':
      return Colors.yellow[800];
      break;
    case 'approved':
      return Colors.blue;
      break;
    case 'withdraw':
      return Colors.red;
      break;
    default:
      return Colors.blueAccent;
      break;
  }
}

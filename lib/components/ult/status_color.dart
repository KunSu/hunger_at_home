import 'package:fe/components/constants.dart';
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
      return hahBlue;
      break;
    case 'withdraw':
      return hahRed;
      break;
    default:
      return hahBorderBlue;
      break;
  }
}

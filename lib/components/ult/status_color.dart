import 'package:fe/components/constants.dart';
import 'package:flutter/material.dart';

Color getStatusColor({String status}) {
  // TODO: define all status as a class with it's name and color
  switch (status) {
    // Start status
    case 'pending':
      return Colors.yellow[800];
      break;
    // Intermediate status
    case 'approved':
      return hahBlue;
      break;
    case 'confirmed':
      return hahBorderBlue;
      break;
    case 'pickedup':
      return Colors.lightGreen;
      break;
    // Final status
    case 'withdraw':
      return hahRed;
      break;
    case 'cancelled':
      return hahRed;
      break;
    case 'deleted':
      return hahRed;
      break;
    case 'delivered':
      return Colors.green;
      break;
    case 'received':
      return Colors.green;
      break;
    case 'dropedoff':
      return Colors.green;
      break;
    case 'archived':
      return Colors.green;
      break;
    default:
      return hahBorderBlue;
      break;
  }
}

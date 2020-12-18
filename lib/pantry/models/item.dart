import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Item extends Equatable {
  Item({
    @required this.id,
    @required this.name,
    @required this.category,
    // @required this.pickupDateAndTime,
    @required this.quantityUnit,
    @required this.quantityNumber,
    // @required this.address
  });

  final String id;
  final String name;
  final String category;
  // final String pickupDateAndTime;
  final String quantityUnit;
  final String quantityNumber;
  // final String address;

  @override
  List<Object> get props => [
        id,
        name,
        category,
        // pickupDateAndTime,
        quantityUnit,
        quantityNumber,
        // address
      ];
}

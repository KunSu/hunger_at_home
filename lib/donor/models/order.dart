import 'package:equatable/equatable.dart';
import 'package:fe/address/address.dart';
import 'package:fe/pantry/models/item.dart';
import 'package:flutter/material.dart';

@immutable
class Order extends Equatable {
  Order(
      {@required this.id,
      @required this.name,
      // @required this.company,
      @required this.itemes,
      @required this.pickupDateAndTime,
      @required this.address});

  final String id;
  final String name;
  final List<Item> itemes;
  final String pickupDateAndTime;
  final Address address;

  @override
  List<Object> get props => [id, name, itemes, pickupDateAndTime, address];
}

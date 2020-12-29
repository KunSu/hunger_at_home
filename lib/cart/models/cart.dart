import 'package:equatable/equatable.dart';
import 'package:fe/order/models/model.dart';
import 'package:flutter/foundation.dart';

@immutable
class Cart extends Equatable {
  const Cart({this.items = const <Item>[]});

  final List<Item> items;

  int get totalPrice => items.fold(0, (total, current) => total + 1);

  @override
  List<Object> get props => [items];
}

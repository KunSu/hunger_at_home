import 'package:equatable/equatable.dart';
import 'package:fe/order/models/model.dart';
import 'package:flutter/foundation.dart';

@immutable
class Catalog extends Equatable {
  static final _itemes = [
    Item(
      id: '1',
      name: 'Avocado',
      category: 'category',
      // pickupDateAndTime: 'Sept 15, 2020',
      quantityUnit: '50',
      quantityNumber: 'lbs',
      // address: 'address'
    ),
    Item(
      id: '2',
      name: 'Baugette',
      category: 'category',
      // pickupDateAndTime: 'Sept 15, 2020',
      quantityUnit: '50',
      quantityNumber: 'lbs',
      // address: 'address'
    ),
    Item(
      id: '3',
      name: 'Fish',
      category: 'category',
      // pickupDateAndTime: 'Sept 15, 2020',
      quantityUnit: '50',
      quantityNumber: 'lbs',
      // address: 'address'
    ),
    Item(
      id: '4',
      name: 'Shrimp',
      category: 'category',
      // pickupDateAndTime: 'Sept 15, 2020',
      quantityUnit: '50',
      quantityNumber: 'lbs',
      // address: 'address'
    ),
  ];

  Item getByPosition(int position) => _itemes[position % _itemes.length];

  @override
  List<Object> get props => [_itemes];
}

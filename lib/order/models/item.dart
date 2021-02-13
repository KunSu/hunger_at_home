import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Item extends Equatable {
  Item({
    this.id,
    @required this.name,
    @required this.category,
    @required this.quantityUnit,
    @required this.quantityNumber,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      quantityUnit: json['unit'],
      quantityNumber: json['quantity'],
    );
  }

  Map<String, dynamic> toJSON() {
    final data = <String, dynamic>{};
    // data['id'] = id;
    data['name'] = name;
    data['category'] = category;
    data['unit'] = quantityUnit;
    data['quantity'] = quantityNumber;
    data['expireDate'] = '2019-09-09';
    data['temperature'] = 'NA';
    return data;
  }

  final String id;
  final String name;
  final String category;
  final String quantityUnit;
  final String quantityNumber;
  // final String expireDate;

  @override
  List<Object> get props => [
        id,
        name,
        category,
        quantityUnit,
        quantityNumber,
      ];

  @override
  String toString() {
    return '$name $quantityNumber $quantityUnit';
  }
}

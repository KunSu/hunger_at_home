import 'package:equatable/equatable.dart';
import 'package:fe/order/models/model.dart';
import 'package:flutter/material.dart';

@immutable
class Order extends Equatable {
  Order({
    this.id,
    this.type,
    this.name,
    this.items,
    this.status,
    this.address,
    this.pickupDateAndTime = 'Not Available',
    this.submitedDateAndTime,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      type: json['orderType'],
      name: json['name'],
      items: [],
      status: json['status'],
      address: json['address'],
      pickupDateAndTime: json['pickUpTime'],
      submitedDateAndTime: json['timestamp'],
    );
  }

  final String id;
  final String type;
  final String name;
  final List<Item> items;
  final String status;
  final String address;
  final String pickupDateAndTime;
  final String submitedDateAndTime;

  Order copyWith({
    String id,
    String type,
    String name,
    List<Item> items,
    String status,
    String address,
    String pickupDateAndTime,
    String submitedDateAndTime,
  }) {
    return Order(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      items: items ?? this.items,
      status: status ?? this.status,
      address: address ?? this.address,
      pickupDateAndTime: pickupDateAndTime ?? this.pickupDateAndTime,
      submitedDateAndTime: submitedDateAndTime ?? this.submitedDateAndTime,
    );
  }

  @override
  List<Object> get props => [
        id,
        type,
        name,
        items,
        status,
        address,
        pickupDateAndTime,
        submitedDateAndTime,
      ];
}

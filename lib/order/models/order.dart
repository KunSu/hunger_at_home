import 'package:equatable/equatable.dart';
import 'package:fe/order/models/model.dart';
import 'package:flutter/material.dart';

@immutable
class Order extends Equatable {
  // TODO: Clear up Order after it is stable
  Order({
    this.id,
    this.type,
    this.items,
    this.status,
    this.address,
    this.pickupDateAndTime = 'Not Available',
    this.submitedDateAndTime,
    // this.deliveryTemperature,
    // this.deliveryDateAndTime,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      type: json['orderType'],
      items: [],
      status: json['status'],
      address: json['address'],
      pickupDateAndTime: json['pickUpTime'],
      submitedDateAndTime: json['timestamp'],
      // deliveryTemperature: json[''],
      // deliveryDateAndTime: json[''],
    );
  }

  final String id;
  final String type;
  final List<Item> items;
  final String status;
  final String address;
  final String pickupDateAndTime;
  final String submitedDateAndTime;
  // final String deliveryTemperature;
  // final String deliveryDateAndTime;

  Order copyWith({
    String id,
    String type,
    List<Item> items,
    String status,
    String address,
    String pickupDateAndTime,
    String submitedDateAndTime,
    // String deliveryTemperature,
    // String deliveryDateAndTime,
  }) {
    return Order(
      id: id ?? this.id,
      type: type ?? this.type,
      items: items ?? this.items,
      status: status ?? this.status,
      address: address ?? this.address,
      pickupDateAndTime: pickupDateAndTime ?? this.pickupDateAndTime,
      submitedDateAndTime: submitedDateAndTime ?? this.submitedDateAndTime,
      // // // deliveryTemperature: deliveryTemperature ?? this.deliveryTemperature,
      // // // deliveryDateAndTime: deliveryDateAndTime ?? this.deliveryDateAndTime,
    );
  }

  @override
  List<Object> get props => [
        id,
        type,
        items,
        status,
        address,
        pickupDateAndTime,
        submitedDateAndTime,
        // deliveryTemperature,
        // deliveryDateAndTime,
      ];
}

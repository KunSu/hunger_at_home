import 'package:equatable/equatable.dart';
import 'package:fe/order/models/model.dart';
import 'package:flutter/material.dart';

@immutable
class Order extends Equatable {
  Order({
    this.id,
    this.type,
    this.items,
    this.status,
    this.userID,
    this.address,
    this.company,
    this.phoneNumber,
    this.pickupDateAndTime,
    this.submitedDateAndTime,
    this.deliveryTemperature,
    this.deliveryDateAndTime,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['orderID'],
      type: json['orderType'],
      items: [],
      status: json['status'],
      userID: json[''],
      address: json['address'],
      company: json[''],
      phoneNumber: json[''],
      pickupDateAndTime: json['pickUpTime'],
      submitedDateAndTime: json[''],
      deliveryTemperature: json[''],
      deliveryDateAndTime: json[''],
    );
  }

  final String id;
  final String type;
  final List<Item> items;
  final String status;
  final String userID;
  final String address;
  final String company;
  final String phoneNumber;
  final String pickupDateAndTime;
  final String submitedDateAndTime;
  final String deliveryTemperature;
  final String deliveryDateAndTime;

  Order copyWith({
    String id,
    String type,
    List<Item> items,
    String status,
    String userID,
    String address,
    String company,
    String phoneNumber,
    String pickupDateAndTime,
    String submitedDateAndTime,
    String deliveryTemperature,
    String deliveryDateAndTime,
  }) {
    return Order(
      id: id ?? this.id,
      type: type ?? this.type,
      items: items ?? this.items,
      status: status ?? this.status,
      userID: userID ?? this.userID,
      address: address ?? this.address,
      company: company ?? this.company,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      pickupDateAndTime: pickupDateAndTime ?? this.pickupDateAndTime,
      submitedDateAndTime: submitedDateAndTime ?? this.submitedDateAndTime,
      deliveryTemperature: deliveryTemperature ?? this.deliveryTemperature,
      deliveryDateAndTime: deliveryDateAndTime ?? this.deliveryDateAndTime,
    );
  }

  @override
  List<Object> get props => [
        id,
        type,
        items,
        status,
        userID,
        address,
        company,
        pickupDateAndTime,
        submitedDateAndTime,
        deliveryTemperature,
        deliveryDateAndTime,
      ];
}

import 'package:equatable/equatable.dart';
import 'package:fe/pantry/models/models.dart';
import 'package:flutter/material.dart';

@immutable
class Order extends Equatable {
  Order({
    this.id,
    this.name,
    @required this.items,
    this.state,
    this.userID,
    @required this.address,
    this.company,
    this.phoneNumber,
    @required this.pickupDateAndTime,
    this.submitedDateAndTime,
    this.deliveryTemperature,
    this.deliveryDateAndTime,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['orderID'],
      name: json[''],
      items: json['orderItems'],
      state: json['status'],
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
  final String name;
  final List<Item> items;
  final String state;
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
    String name,
    List<Item> items,
    String state,
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
      name: name ?? this.name,
      items: items ?? this.items,
      state: state ?? this.state,
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
        name,
        items,
        state,
        userID,
        address,
        company,
        pickupDateAndTime,
        submitedDateAndTime,
        deliveryTemperature,
        deliveryDateAndTime,
      ];
}

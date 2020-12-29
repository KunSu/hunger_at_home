import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class OrderDetail extends Equatable {
  OrderDetail({
    this.phoneNumber,
    this.companyName,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.pickupTime,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      phoneNumber: json['phoneNumber'],
      companyName: json['companyName'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      pickupTime: json['pickupTime'],
    );
  }

  final String phoneNumber;
  final String companyName;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String pickupTime;

  @override
  List<Object> get props =>
      [phoneNumber, companyName, address, city, state, zipCode, pickupTime];
}

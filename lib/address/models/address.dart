import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Address extends Equatable {
  Address({
    this.id,
    this.address,
    this.city,
    this.state,
    this.zipcode,
    this.isDeleting = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipcode: json['zipCode'],
    );
  }

  final String id;
  final String address;
  final String city;
  final String state;
  final String zipcode;
  final bool isDeleting;

  Address copyWith({
    String id,
    String address,
    String city,
    String state,
    String zipcode,
    bool isDeleting,
  }) {
    return Address(
      id: id ?? this.id,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipcode: zipcode ?? this.zipcode,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }

  @override
  List<Object> get props => [id, address, city, state, zipcode, isDeleting];
}

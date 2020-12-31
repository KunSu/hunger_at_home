import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Company extends Equatable {
  Company({
    this.id,
    this.name,
    this.fedID,
    this.einID,
    this.address,
    this.city,
    this.state,
    this.zipcode,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      fedID: json['fedID'],
      einID: json['einID'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipcode: json['zipCode'],
    );
  }

  final String id;
  final String name;
  final String fedID;
  final String einID;
  final String address;
  final String city;
  final String state;
  final String zipcode;

  Company copyWith({
    String id,
    String name,
    String fedID,
    String einID,
    String address,
    String city,
    String state,
    String zipcode,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      fedID: fedID ?? this.fedID,
      einID: einID ?? this.einID,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipcode: zipcode ?? this.zipcode,
    );
  }

  @override
  List<Object> get props =>
      [id, name, fedID, einID, address, city, state, zipcode];
}

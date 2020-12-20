import 'package:equatable/equatable.dart';
import 'package:fe/pantry/models/models.dart';
import 'package:flutter/material.dart';

@immutable
class Order extends Equatable {
  Order(
      {@required this.id,
      @required this.name,
      @required this.items,
      @required this.userID,
      @required this.address,
      @required this.pickupDateAndTime,
      @required this.submitedDateAndTime});

  final String id;
  final String name;
  final List<Item> items;
  final String userID;
  final String address;
  final String pickupDateAndTime;
  final String submitedDateAndTime;

  Order copyWith({
    String id,
    String name,
    List<Item> items,
    String userID,
    String address,
    String pickupDateAndTime,
    String submitedDateAndTime,
  }) {
    return Order(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
      userID: userID ?? this.userID,
      address: address ?? this.address,
      pickupDateAndTime: pickupDateAndTime ?? this.pickupDateAndTime,
      submitedDateAndTime: submitedDateAndTime ?? this.submitedDateAndTime,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        items,
        userID,
        address,
        pickupDateAndTime,
        submitedDateAndTime,
      ];

  // @override
  // String toString() {
  //   return 'Todo { complete: $complete, task: $task, note: $note, id: $id }';
  // }

  // TodoEntity toEntity() {
  //   return TodoEntity(task, id, note, complete);
  // }

  // static Todo fromEntity(TodoEntity entity) {
  //   return Todo(
  //     entity.task,
  //     complete: entity.complete ?? false,
  //     note: entity.note,
  //     id: entity.id ?? Uuid().generateV4(),
  //   );
  // }
}

// class Todo extends Equatable {
//   final bool complete;
//   final String id;
//   final String note;
//   final String task;

//   Todo(
//     this.task, {
//     this.complete = false,
//     String note = '',
//     String id,
//   })  : this.note = note ?? '',
//         this.id = id ?? Uuid().generateV4();

//   Todo copyWith({bool complete, String id, String note, String task}) {
//     return Todo(
//       task ?? this.task,
//       complete: complete ?? this.complete,
//       id: id ?? this.id,
//       note: note ?? this.note,
//     );
//   }

//   @override
//   List<Object> get props => [complete, id, note, task];

//   @override
//   String toString() {
//     return 'Todo { complete: $complete, task: $task, note: $note, id: $id }';
//   }

//   TodoEntity toEntity() {
//     return TodoEntity(task, id, note, complete);
//   }

//   static Todo fromEntity(TodoEntity entity) {
//     return Todo(
//       entity.task,
//       complete: entity.complete ?? false,
//       note: entity.note,
//       id: entity.id ?? Uuid().generateV4(),
//     );
//   }
// }

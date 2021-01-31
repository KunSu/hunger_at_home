part of 'orders_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class OrdersStarted extends OrdersEvent {
  @override
  List<Object> get props => [];
}

class OrdersLoaded extends OrdersEvent {}

class OrderAdded extends OrdersEvent {
  const OrderAdded(this.order);

  final Order order;

  @override
  List<Object> get props => [order];

  @override
  String toString() => 'OrderAdded { order: $order }';
}

class OrderUpdated extends OrdersEvent {
  const OrderUpdated(this.order);

  final Order order;

  @override
  List<Object> get props => [order];

  @override
  String toString() => 'OrderUpdated { updatedOrder: $order }';
}

class OrderDeleted extends OrdersEvent {
  const OrderDeleted(this.order);

  final Order order;

  @override
  List<Object> get props => [order];

  @override
  String toString() => 'OrderDeleted { order: $order }';
}

class OrderEdited extends OrdersEvent {
  const OrderEdited(this.order);

  final Order order;

  @override
  List<Object> get props => [order];

  @override
  String toString() => 'OrderEdited { editedOrder: $order }';
}

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
  final Order order;

  const OrderAdded(this.order);

  @override
  List<Object> get props => [order];

  @override
  String toString() => 'OrderAdded { order: $order }';
}

class OrderUpdated extends OrdersEvent {
  final Order order;

  const OrderUpdated(this.order);

  @override
  List<Object> get props => [order];

  @override
  String toString() => 'OrderUpdated { updatedOrder: $order }';
}

class OrderDeleted extends OrdersEvent {
  final Order order;

  const OrderDeleted(this.order);

  @override
  List<Object> get props => [order];

  @override
  String toString() => 'OrderDeleted { order: $order }';
}

class ClearCompleted extends OrdersEvent {}

class ToggleAll extends OrdersEvent {}

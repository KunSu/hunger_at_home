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

class OrderLoadSummary extends OrdersEvent {
  const OrderLoadSummary(
      {this.userID,
      this.startDate,
      this.endDate,
      this.type,
      this.status,
      this.download,
      });

  final String userID;
  final String startDate;
  final String endDate;
  final Set<String> type;
  final Set<String> status;
  final bool download;

  @override
  List<Object> get props =>
      [userID, startDate, endDate, type, status, download];

  // @override
  // String toString() => 'OrderLoadSummary { order: $userID }';
}

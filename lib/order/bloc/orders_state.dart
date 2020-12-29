part of 'orders_bloc.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

class OrdersLoadInProgress extends OrdersState {}

class OrdersLoadSuccess extends OrdersState {
  const OrdersLoadSuccess([this.orders = const []]);

  final List<Order> orders;

  @override
  List<Object> get props => [orders];

  @override
  String toString() => 'OrdersLoadSuccess { orders: $orders }';
}

class OrdersLoadFailure extends OrdersState {
  const OrdersLoadFailure(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}

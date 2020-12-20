part of 'orders_bloc.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

class OrdersLoadInProgress extends OrdersState {}

class OrdersLoadSuccess extends OrdersState {
  final List<Order> orders;

  const OrdersLoadSuccess([this.orders = const []]);

  @override
  List<Object> get props => [orders];

  @override
  String toString() => 'OrdersLoadSuccess { orders: $orders }';
}

class OrdersLoadFailure extends OrdersState {}

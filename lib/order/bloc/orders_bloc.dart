import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fe/order/models/model.dart';
import 'package:meta/meta.dart';

// TODO: repo
import '../order_repository.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository ordersRepository;

  OrdersBloc({@required this.ordersRepository}) : super(OrdersLoadInProgress());

  @override
  Stream<OrdersState> mapEventToState(OrdersEvent event) async* {
    if (event is OrdersLoaded) {
      yield* _mapOrdersLoadedToState();
    } else if (event is OrderAdded) {
      yield* _mapOrderAddedToState(event);
    } else if (event is OrderUpdated) {
      yield* _mapOrderUpdatedToState(event);
    } else if (event is OrderDeleted) {
      yield* _mapOrderDeletedToState(event);
    }
    // else if (event is ToggleAll) {
    //   yield* _mapToggleAllToState();
    // } else if (event is ClearCompleted) {
    //   yield* _mapClearCompletedToState();
    // }
  }

  Stream<OrdersState> _mapOrdersLoadedToState() async* {
    try {
      final orders = await this.ordersRepository.loadOrders();
      yield OrdersLoadSuccess(
        orders,
      );
    } catch (_) {
      yield OrdersLoadFailure();
    }
  }

  Stream<OrdersState> _mapOrderAddedToState(OrderAdded event) async* {
    if (state is OrdersLoadSuccess) {
      final List<Order> updatedOrders =
          List.from((state as OrdersLoadSuccess).orders)..add(event.order);
      yield OrdersLoadSuccess(updatedOrders);
      _saveOrders(updatedOrders);
    }
  }

  Stream<OrdersState> _mapOrderUpdatedToState(OrderUpdated event) async* {
    if (state is OrdersLoadSuccess) {
      final List<Order> updatedOrders =
          (state as OrdersLoadSuccess).orders.map((order) {
        return order.id == event.order.id ? event.order : order;
      }).toList();
      yield OrdersLoadSuccess(updatedOrders);
      _saveOrders(updatedOrders);
    }
  }

  Stream<OrdersState> _mapOrderDeletedToState(OrderDeleted event) async* {
    if (state is OrdersLoadSuccess) {
      final updatedOrders = (state as OrdersLoadSuccess)
          .orders
          .where((order) => order.id != event.order.id)
          .toList();
      yield OrdersLoadSuccess(updatedOrders);
      _saveOrders(updatedOrders);
    }
  }

  // Stream<OrdersState> _mapToggleAllToState() async* {
  //   if (state is OrdersLoadSuccess) {
  //     final allComplete =
  //         (state as OrdersLoadSuccess).orders.every((order) => order.complete);
  //     final List<Order> updatedOrders = (state as OrdersLoadSuccess)
  //         .orders
  //         .map((order) => order.copyWith(complete: !allComplete))
  //         .toList();
  //     yield OrdersLoadSuccess(updatedOrders);
  //     _saveOrders(updatedOrders);
  //   }
  // }

  // Stream<OrdersState> _mapClearCompletedToState() async* {
  //   if (state is OrdersLoadSuccess) {
  //     final List<Order> updatedOrders = (state as OrdersLoadSuccess)
  //         .orders
  //         .where((order) => !order.complete)
  //         .toList();
  //     yield OrdersLoadSuccess(updatedOrders);
  //     _saveOrders(updatedOrders);
  //   }
  // }

  Future _saveOrders(List<Order> orders) {
    return ordersRepository.saveOrders(
      orders,
    );
  }
}

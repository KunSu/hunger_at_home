import 'dart:async';
import 'dart:core';

import 'package:fe/order/models/order.dart';

// import 'todo_entity.dart';

/// A class that Loads and Persists todos. The data layer of the app.
///
/// How and where it stores the entities should defined in a concrete
/// implementation, such as todos_repository_simple or todos_repository_web.
///
/// The domain layer should depend on this abstract class, and each app can
/// inject the correct implementation depending on the environment, such as
/// web or Flutter.
class OrdersRepository {
  /// Loads todos first from File storage. If they don't exist or encounter an
  /// error, it attempts to load the Todos from a Web Client.
  OrdersRepository() {
    orders = <Order>[];
  }
  List<Order> orders;
  List<Order> loadOrders() {
    return orders;
  }

  // Persists todos to local disk and the web
  saveOrders(List<Order> orders) {
    orders = orders ?? this.orders;
  }
}

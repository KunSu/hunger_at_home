import 'dart:core';
import 'package:fe/order/models/model.dart';

class ItemsRepository {
  ItemsRepository() {
    items = <Item>[];
  }

  List<Item> items;
  List<Item> loadItems() {
    return items;
  }

  saveItems(List<Item> items) {
    items = items ?? this.items;
  }

  void add(Item item) {
    items.add(item);
  }

  void reset() {
    items = <Item>[];
  }
}

import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/order/models/model.dart';
import 'package:fe/order/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class OrderEditFormBloc extends FormBloc<String, String> {
  OrderEditFormBloc({
    @required this.authenticationRepository,
    @required this.ordersRepository,
    this.order,
  }) : super(isLoading: true) {
    removeFieldBlocs(
      fieldBlocs: [
        pickupDateAndTime,
      ],
    );
    addFieldBlocs(
      fieldBlocs: [
        name,
      ],
    );
    if (order.type == 'request') {
      addFieldBlocs(
        fieldBlocs: [
          pickupDateAndTime,
        ],
      );
    } else if (order.type == 'donation') {
      addFieldBlocs(
        fieldBlocs: [
          pickupOrDropoff,
          pickupDateAndTime,
        ],
      );
    } else if (order.type == 'dropoff') {
      addFieldBlocs(
        fieldBlocs: [
          pickupOrDropoff,
        ],
      );
    }

    pickupOrDropoff.onValueChanges(
      onData: (previous, current) async* {
        removeFieldBlocs(
          fieldBlocs: [
            pickupDateAndTime,
          ],
        );
        if (current.value == 'Pick up') {
          addFieldBlocs(
            fieldBlocs: [
              pickupDateAndTime,
            ],
          );
        } else if (current.value == 'Drop off') {
          addFieldBlocs(
            fieldBlocs: [],
          );
        }
      },
    );
  }

  final OrdersRepository ordersRepository;
  final AuthenticationRepository authenticationRepository;
  Order order;

  final pickupOrDropoff = SelectFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
    items: ['Pick up', 'Drop off'],
  );

  final pickupDateAndTime = InputFieldBloc<DateTime, Object>(
    validators: [
      FieldBlocValidators.required,
    ],
    name: 'pickupDateAndTime',
    toJson: (value) => value.toUtc().toIso8601String(),
  );

  final name = TextFieldBloc();

  @override
  Future<void> onLoading() async {
    super.onLoading();

    name.updateInitialValue(order.name);
    try {
      final items = await ordersRepository.loadOrderItems(orderID: order.id);
      order = order.copyWith(items: items);
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }

    if (order.type == 'donation') {
      pickupOrDropoff.updateInitialValue('Pick up');
    } else if (order.type == 'dropoff') {
      pickupOrDropoff.updateInitialValue('Drop off');
    }
    if (order.type == 'donation' || order.type == 'request') {
      pickupDateAndTime
          .updateInitialValue(DateTime.parse(order.pickupDateAndTime));
    }
    emitLoaded();
  }

  @override
  void onSubmitting() async {
    if (order.items.isEmpty) {
      emitFailure(failureResponse: 'Item can not be empty');
      return;
    }

    try {
      if (order.type == 'request') {
        await ordersRepository
            .editOrder(
              name: name.value,
              userID: authenticationRepository.user.id,
              addressID: '-1', // It is not used for API
              orderType: 'request',
              pickUpTime: pickupDateAndTime.value.toString(),
              order: order,
            )
            .then((order) => this.order = order);
      } else if (order.type == 'anonymous') {
        await ordersRepository
            .editOrder(
              name: name.value,
              userID: authenticationRepository.user.id,
              addressID: '-1', // It is not used for API
              orderType: 'anonymous',
              pickUpTime: 'Not Available',
              order: order,
            )
            .then((order) => this.order = order);
      } else {
        await ordersRepository
            .editOrder(
              name: name.value,
              userID: authenticationRepository.user.id,
              addressID: '-1', // It is not used for API
              orderType:
                  pickupOrDropoff.value == 'Pick up' ? 'donation' : 'dropoff',
              pickUpTime: pickupOrDropoff.value == 'Pick up'
                  ? pickupDateAndTime.value.toString()
                  : DateTime.fromMicrosecondsSinceEpoch(0).toString(),
              order: order,
            )
            .then((order) => this.order = order);
      }
    } catch (e) {
      emitFailure(failureResponse: e.toString());
      return;
    }
    emitSuccess(
      canSubmitAgain: true,
    );
  }

  void reset() {
    order = null;
  }

  void updateItem(Item updatedItem) {
    final items = order.items.map((item) {
      return item.id == updatedItem.id ? updatedItem : item;
    }).toList();
    order = order.copyWith(items: items);
    emitSubmitting();
    emitLoaded();
  }

  void removeItem(Item item) {
    order.items.remove(item);
  }

  void reloadItems() {
    try {
      ordersRepository.loadOrderItems(orderID: order.id).then((value) {
        order = order.copyWith(items: value);
      });
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }
  }
}

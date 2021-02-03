import 'package:authentication_repository/authentication_repository.dart';
// import 'package:fe/address/address.dart';
import 'package:fe/order/models/model.dart';
import 'package:fe/order/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class OrderEditFormBloc extends FormBloc<String, String> {
  OrderEditFormBloc({
    @required this.authenticationRepository,
    // @required this.addressesRepository,
    @required this.ordersRepository,
    this.order,
  }) : super(isLoading: true) {
    removeFieldBlocs(
      fieldBlocs: [
        pickupDateAndTime,
        // addresses,
        // dropoffAddress,
      ],
    );
    if (order.type == 'request') {
      addFieldBlocs(
        fieldBlocs: [
          pickupDateAndTime,
          // addresses,
        ],
      );
    } else if (order.type == 'donation') {
      addFieldBlocs(
        fieldBlocs: [
          pickupOrDropoff,
          pickupDateAndTime,
          // addresses,
        ],
      );
    } else if (order.type == 'dropoff') {
      addFieldBlocs(
        fieldBlocs: [
          pickupOrDropoff,
          // dropoffAddress,
        ],
      );
    }

    pickupOrDropoff.onValueChanges(
      onData: (previous, current) async* {
        removeFieldBlocs(
          fieldBlocs: [
            pickupDateAndTime,
            // addresses,
            // dropoffAddress,
          ],
        );
        if (current.value == 'Pick up') {
          addFieldBlocs(
            fieldBlocs: [
              pickupDateAndTime,
              // addresses,
            ],
          );
        } else if (current.value == 'Drop off') {
          addFieldBlocs(
            fieldBlocs: [
              // dropoffAddress,
            ],
          );
        }
      },
    );
  }

  final OrdersRepository ordersRepository;
  // final AddressesRepository addressesRepository;
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

  // final addresses = SelectFieldBloc(
  //   validators: [
  //     FieldBlocValidators.required,
  //   ],
  // );

  // final dropoffAddress = SelectFieldBloc(
  //   validators: [
  //     FieldBlocValidators.required,
  //   ],
  //   items: ['1534 berger drive, san jose, ca 95112'],
  // );

  @override
  Future<void> onLoading() async {
    super.onLoading();

    try {
      final items = await ordersRepository.loadOrderItems(orderID: order.id);
      order = order.copyWith(items: items);

      // var companyID = authenticationRepository.user.companyID;
      // if (authenticationRepository.user.userIdentity == 'recipient') {
      //   companyID = '1'; // Hunger at Home default id
      // }
      // var newAddresses =
      //     await addressesRepository.loadAddressNames(companyID: companyID);
      // addresses.updateItems(newAddresses);
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }

    if (order.type == 'donation') {
      pickupOrDropoff.updateInitialValue('Pick up');
    } else if (order.type == 'dropoff') {
      pickupOrDropoff.updateInitialValue('Drop off');
    }
    if (order.type != 'dropoff') {
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
              userID: authenticationRepository.user.id,
              addressID: '-1', // It is not used for API
              // addressID: addressesRepository.getAddressID(
              //   addresses.value,
              // ),
              orderType: 'request',
              pickUpTime: pickupDateAndTime.value.toString(),
              order: order,
            )
            .then((order) => this.order = order);
      } else {
        await ordersRepository
            .editOrder(
              userID: authenticationRepository.user.id,
              addressID: '-1', // It is not used for API
              // addressID: pickupOrDropoff.value == 'Pick up'
              //     ? addressesRepository.getAddressID(
              //         addresses.value,
              //       )
              //     : '1', // Default drop off address ID is 1 for Hunger at Home
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

  // String getAddressID() {
  //   return addressesRepository.getAddressID(addresses.value);
  // }

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

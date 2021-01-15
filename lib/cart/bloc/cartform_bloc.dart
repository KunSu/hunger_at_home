import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/address/address.dart';
import 'package:fe/order/models/model.dart';
import 'package:fe/order/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class CartFormBloc extends FormBloc<String, String> {
  CartFormBloc({
    @required this.authenticationRepository,
    @required this.addressesRepository,
    @required this.ordersRepository,
  }) {
    if (authenticationRepository.user.userIdentity == 'recipient') {
      addFieldBlocs(
        fieldBlocs: [
          pickupDateAndTime,
          addresses,
        ],
      );
    } else {
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
            addresses,
            dropoffAddress,
          ],
        );
        if (current.value == 'Pick up') {
          addFieldBlocs(
            fieldBlocs: [
              pickupDateAndTime,
              addresses,
            ],
          );
        } else if (current.value == 'Drop off') {
          addFieldBlocs(
            fieldBlocs: [
              dropoffAddress,
            ],
          );
        }
      },
    );
  }

  final OrdersRepository ordersRepository;
  final AddressesRepository addressesRepository;
  final AuthenticationRepository authenticationRepository;

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

  final addresses = SelectFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final dropoffAddress = SelectFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
    items: ['1534 Berger Drive, San Jose, CA 95112'],
  );

  List<Item> items;
  Order order;

  @override
  void onSubmitting() async {
    final identity = authenticationRepository.user.userIdentity;
    if (items.isEmpty) {
      emitFailure(failureResponse: 'Item can not be empty');
      return;
    }

    try {
      if (authenticationRepository.user.userIdentity == 'recipient') {
        await ordersRepository
            .signUp(
              userID: authenticationRepository.user.id,
              addressID: addressesRepository.getAddressID(
                addresses.value,
              ),
              orderType: 'request',
              pickUpTime: pickupDateAndTime.value.toString(),
              status: 'pending',
              orderItems: items,
            )
            .then((order) => this.order = order);
      } else {
        await ordersRepository
            .signUp(
              userID: authenticationRepository.user.id,
              addressID: pickupOrDropoff.value == 'Pick up'
                  ? addressesRepository.getAddressID(
                      addresses.value,
                    )
                  : '1', // Default drop off address ID is 1 for Hunger at Home
              orderType:
                  pickupOrDropoff.value == 'Pick up' ? 'donation' : 'dropoff',
              pickUpTime: pickupOrDropoff.value == 'Pick up'
                  ? pickupDateAndTime.value.toString()
                  : DateTime.fromMicrosecondsSinceEpoch(0).toString(),
              status: 'pending',
              orderItems: items,
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

  String getAddressID() {
    return addressesRepository.getAddressID(addresses.value);
  }

  void reset() {
    order = null;
    items = [];
  }
}

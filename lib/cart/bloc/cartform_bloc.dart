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
    addFieldBlocs(
      fieldBlocs: [
        pickupOrDropoff,
      ],
    );

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
          await onLoading();
          addFieldBlocs(
            fieldBlocs: [
              pickupDateAndTime,
              addresses,
            ],
          );
        } else {
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
    if (items.isEmpty) {
      emitFailure(failureResponse: 'Item can not be empty');
      return;
    }

    // try {
    //   order = await ordersRepository.signUp(
    //     userID: authenticationRepository.user.id,
    //     addressID: addressesRepository.getAddressID(
    //       addresses.value,
    //     ),
    //     orderType: authenticationRepository.user.userIdentity == 'donor'
    //         ? 'donation'
    //         : 'request',
    //     pickUpTime: pickupDateAndTime.value.toString(),
    //     status: 'pending',
    //     orderItems: items,
    //   );
    //   emitSuccess(
    //     canSubmitAgain: true,
    //   );
    // } catch (e) {
    //   emitFailure(failureResponse: e.toString());
    // }
  }

  @override
  Future<void> onLoading() async {
    try {
      var companyID = authenticationRepository.user.companyID;
      print(authenticationRepository.user.userIdentity);
      if (authenticationRepository.user.userIdentity == 'recipient') {
        companyID = '1'; // Hunger at Home default id
      }
      var newAddresses =
          await addressesRepository.loadAddressNames(companyID: companyID);

      addresses.clear();
      for (var item in newAddresses) {
        addresses.addItem(item);
      }
      emitLoaded();
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }
  }

  String getAddressID() {
    return addressesRepository.getAddressID(addresses.value);
  }
}

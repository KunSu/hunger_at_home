import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/address/address.dart';
import 'package:fe/item/item_repository.dart';
import 'package:fe/order/models/model.dart';
import 'package:fe/order/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class AnonymousOrderBloc extends FormBloc<String, String> {
  AnonymousOrderBloc({
    @required this.authenticationRepository,
    @required this.addressesRepository,
    @required this.ordersRepository,
    @required this.itemsRepository,
  }) : super(isLoading: true) {
    addFieldBlocs(
      fieldBlocs: [
        name,
        addresses,
      ],
    );
  }

  final OrdersRepository ordersRepository;
  final AddressesRepository addressesRepository;
  final AuthenticationRepository authenticationRepository;
  final ItemsRepository itemsRepository;
  final addresses = SelectFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final name = TextFieldBloc();
  Order order = Order();

  @override
  Future<void> onLoading() async {
    super.onLoading();
    name.updateInitialValue(order.name);
    try {
      final companyID = '1'; // Hunger at Home default id
      var newAddresses =
          await addressesRepository.loadAddressNames(companyID: companyID);
      addresses.updateItems(newAddresses);

      order = order.copyWith(items: itemsRepository.loadItems());
    } catch (e) {
      emitFailure(failureResponse: e.toString());
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
      await ordersRepository
          .anonymousOrder(
            name: name.value,
            userID: authenticationRepository.user.id,
            addressID: addressesRepository.getAddressID(
              addresses.value,
            ),
            orderType: 'anonymous',
            items: order.items,
          )
          .then((order) => this.order = order);
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
    itemsRepository.reset();
  }
}

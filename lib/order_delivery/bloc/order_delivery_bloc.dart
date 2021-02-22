import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order/order_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:meta/meta.dart';

class OrderDeliveryBloc extends FormBloc<String, String> {
  OrderDeliveryBloc({
    @required this.authenticationRepository,
    @required this.ordersRepository,
  }) {
    addFieldBlocs(
      fieldBlocs: [
        time,
        temperature,
      ],
    );

    temperature.addValidators([_checkTemperatureUnit]);
  }
  final OrdersRepository ordersRepository;
  final AuthenticationRepository authenticationRepository;

  final time = InputFieldBloc<TimeOfDay, Object>(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final temperature = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  Order order;

  @override
  void onSubmitting() async {
    try {
      final newOrder = await ordersRepository.delivered(
        userID: authenticationRepository.user.id,
        orderID: order.id,
        temperature: temperature.value,
      );
      order = newOrder;
      emitSuccess(
        canSubmitAgain: true,
      );
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }
  }

  String _checkTemperatureUnit(String string) {
    string = string.trim();
    if (string.endsWith('C') || string.endsWith('F')) return null;
    return 'Temperature must ends with a C or F';
  }
}

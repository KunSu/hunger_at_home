import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/order/order_repository.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:meta/meta.dart';

class OrderPickupBloc extends FormBloc<String, String> {
  OrderPickupBloc({
    @required this.authenticationRepository,
    @required this.ordersRepository,
  }) {
    addFieldBlocs(
      fieldBlocs: [
        foodNameCheck,
        quantityCheck,
        expirationCheck,
      ],
    );
  }
  final OrdersRepository ordersRepository;
  final AuthenticationRepository authenticationRepository;

  final foodNameCheck = BooleanFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final quantityCheck = BooleanFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final expirationCheck = BooleanFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  String orderID;

  @override
  void onSubmitting() async {
    emitSuccess(
      canSubmitAgain: true,
    );
  }
}

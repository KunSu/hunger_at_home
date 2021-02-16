import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/order/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderSummaryBloc extends FormBloc<String, String> {
  OrderSummaryBloc({
    @required this.authenticationRepository,
    @required this.ordersRepository,
  }) {
    addFieldBlocs(
      fieldBlocs: [
        startDate,
        endDate,
        type,
        status,
      ],
    );
  }

  final OrdersRepository ordersRepository;
  final AuthenticationRepository authenticationRepository;

  final startDate = InputFieldBloc<DateTime, Object>(
    validators: [
      FieldBlocValidators.required,
    ],
    initialValue: DateTime.now().subtract(const Duration(days: 7)),
    name: 'startDate',
    toJson: (value) => value.toUtc().toIso8601String(),
  );

  final endDate = InputFieldBloc<DateTime, Object>(
    validators: [
      FieldBlocValidators.required,
    ],
    initialValue: DateTime.now(),
    name: 'endDate',
    toJson: (value) => value.toUtc().toIso8601String(),
  );

  final type = SelectFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
    initialValue: 'all',
    items: [
      'all',
      'donation',
      'dropoff',
      'request',
      'anonymous',
    ],
  );

  final status = SelectFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
    initialValue: 'all',
    items: [
      'all',
      'pending',
      'approved',
      'confirmed',
      'pickedup',
      'droppedoff',
      'delivered',
      'received',
      'withdraw',
      'canceled',
      'archived',
      'deleted',
    ],
  );

  bool download = false;

  @override
  void onSubmitting() async {
    if (download) {
      setDownload(false);
      try {
        var url = await ordersRepository.downloadOrderSummary(
          userID: authenticationRepository.user.id,
          startDate: startDate.value.toIso8601String(),
          endDate: endDate.value.toIso8601String(),
          type: <String>{type.value},
          status: <String>{status.value},
        );
        url = '${FlutterConfig.get('DOWNLOAD_URL')}/$url';
        print(url);
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          emitFailure(failureResponse: 'Could not launch $url');
        }
      } catch (e) {
        emitFailure(failureResponse: e.toString());
        return;
      }
      emitLoaded();
    } else {
      emitSuccess();
    }
  }

  void setDownload(bool isDownload) {
    download = isDownload;
  }
}

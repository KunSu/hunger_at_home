import 'package:fe/order/models/model.dart';
import 'package:fe/order_edit/bloc/order_edit_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class ItemEditBloc extends FormBloc<String, String> {
  ItemEditBloc({
    @required this.orderEditFormBloc,
    @required this.item,
  }) : super(isLoading: true) {
    addFieldBlocs(
      fieldBlocs: [
        name,
        category,
        quantityNumber,
        quantityUnit,
      ],
    );
  }

  final OrderEditFormBloc orderEditFormBloc;

  final name = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final category = SelectFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
    items: [
      'fruit',
      'veggies',
      'meat',
      'seafood',
      'dry',
      'others',
    ],
  );

  final quantityNumber = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );
  final quantityUnit = SelectFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
    items: [
      'case',
      'each',
      'pallet',
      'pound',
      'gallons',
    ],
  );
  Item item;

  @override
  void onLoading() {
    super.onLoading();
    name.updateInitialValue(item.name);
    category.updateInitialValue(item.category.toLowerCase());
    quantityNumber.updateInitialValue(item.quantityNumber);
    quantityUnit.updateInitialValue(item.quantityUnit);
    emitLoaded();
  }

  @override
  void onSubmitting() async {
    item = Item(
      id: item.id,
      name: name.value,
      category: category.value,
      quantityNumber: quantityNumber.value,
      quantityUnit: quantityUnit.value,
    );
    try {
      orderEditFormBloc.updateItem(item);
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }
    emitSuccess(
      canSubmitAgain: true,
    );
  }
}

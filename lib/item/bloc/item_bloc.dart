import 'package:fe/order/models/model.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class ItemBloc extends FormBloc<String, String> {
  ItemBloc() {
    addFieldBlocs(
      fieldBlocs: [
        name,
        category,
        quantityNumber,
        quantityUnit,
      ],
    );
  }

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
      'Fruits',
      'Veggies',
      'Meat',
      'Seafood',
      'Dry',
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
      'pallet',
      'case',
      'pound',
    ],
  );
  Item item;

  @override
  void onSubmitting() async {
    item = Item(
      name: name.value,
      category: category.value,
      quantityNumber: quantityNumber.value,
      quantityUnit: quantityUnit.value,
    );
    emitSuccess(
      canSubmitAgain: true,
    );
  }
}

import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class DonateBloc extends FormBloc<String, String> {
  DonateBloc() {
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

  @override
  void onSubmitting() async {
    emitSuccess(
      canSubmitAgain: true,
    );
  }
}

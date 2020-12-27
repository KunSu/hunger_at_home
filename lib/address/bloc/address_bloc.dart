import 'package:fe/address/address.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:meta/meta.dart';

class AddressBloc extends FormBloc<String, String> {
  AddressBloc({
    @required this.addressesRepository,
  }) {
    addFieldBlocs(
      fieldBlocs: [
        address,
        city,
        usState,
        zipCode,
      ],
    );
  }
  final AddressesRepository addressesRepository;

  final address = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final city = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final usState = SelectFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
    items: [
      'Alabama',
      'Alaska',
      'Arizona',
      'Arkansas',
      'California',
      'Colorado',
      'Connecticut',
      'Delaware',
      'Florida',
      'Georgia',
      'Hawaii',
      'Idaho',
      'Illinois',
      'Indiana',
      'Iowa',
      'Kansas',
      'Kentucky',
      'Louisiana',
      'Maine',
      'Maryland',
      'Massachusetts',
      'Michigan',
      'Minnesota',
      'Mississippi',
      'Missouri',
      'Montana',
      'Nebraska',
      'Nevada',
      'New Hampshire',
      'New Jersey',
      'New Mexico',
      'New York',
      'North Carolina',
      'North Dakota',
      'Ohio',
      'Oklahoma',
      'Oregon',
      'Pennsylvania',
      'Rhode Island',
      'South Carolina',
      'South Dakota',
      'Tennessee',
      'Texas',
      'Utah',
      'Vermont',
      'Virginia',
      'Washington',
      'West Virginia',
      'Wisconsin',
      'Wyoming',
    ],
  );

  final zipCode = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  @override
  void onSubmitting() async {
    var newAddress = await addressesRepository.signUp(
      address: address.value,
      city: city.value,
      state: usState.value,
      zipCode: zipCode.value,
    );

    if (newAddress != null) {
      emitSuccess(
        canSubmitAgain: true,
      );
    } else {
      emitFailure();
    }
  }
}

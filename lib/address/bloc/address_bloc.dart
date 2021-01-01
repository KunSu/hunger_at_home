import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/address/address.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:meta/meta.dart';

class AddressBloc extends FormBloc<String, String> {
  AddressBloc({
    @required this.authenticationRepository,
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

  final AuthenticationRepository authenticationRepository;
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
      'AL',
      'AK',
      'AS',
      'AZ',
      'AR',
      'CA',
      'CO',
      'CT',
      'DE',
      'DC',
      'FM',
      'FL',
      'GA',
      'GU',
      'HI',
      'ID',
      'IL',
      'IN',
      'IA',
      'KS',
      'KY',
      'LA',
      'ME',
      'MH',
      'MD',
      'MA',
      'MI',
      'MN',
      'MS',
      'MO',
      'MT',
      'NE',
      'NV',
      'NH',
      'NJ',
      'NM',
      'NY',
      'NC',
      'ND',
      'MP',
      'OH',
      'OK',
      'OR',
      'PW',
      'PA',
      'PR',
      'RI',
      'SC',
      'SD',
      'TN',
      'TX',
      'UT',
      'VT',
      'VI',
      'VA',
      'WA',
      'WV',
      'WI',
      'WY',
    ],
  );

  final zipCode = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  @override
  void onSubmitting() async {
    try {
      await addressesRepository.signUp(
        address: address.value,
        city: city.value,
        state: usState.value,
        zipCode: zipCode.value,
        userID: authenticationRepository.user.id,
      );
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }
    emitSuccess(
      canSubmitAgain: true,
    );
  }
}

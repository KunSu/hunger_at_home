import 'package:fe/company/company.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:meta/meta.dart';

class CompanyBloc extends FormBloc<String, String> {
  CompanyBloc({
    @required this.companiesRepository,
  }) {
    _companyID = '-1';
    addFieldBlocs(
      fieldBlocs: [
        havingCompany,
      ],
    );

    havingCompany.onValueChanges(
      onData: (previous, current) async* {
        removeFieldBlocs(
          fieldBlocs: [
            companies,
            name,
            fedID,
            einID,
            address,
            city,
            usState,
            zipCode,
          ],
        );
        if (current.value == 'Yes') {
          await onLoading();
          addFieldBlocs(
            fieldBlocs: [companies],
          );
        } else {
          addFieldBlocs(
            fieldBlocs: [
              name,
              fedID,
              einID,
              address,
              city,
              usState,
              zipCode,
            ],
          );
        }
      },
    );
  }

  final CompaniesRepository companiesRepository;

  final havingCompany = SelectFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
    items: ['Yes', 'No'],
  );

  final companies = SelectFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final name = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final fedID = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );
  final einID = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

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
  var _companyID;

  @override
  void onSubmitting() async {
    if (havingCompany.value == 'No') {
      try {
        var newCompany = await companiesRepository.signUp(
          name: name.value,
          fedID: fedID.value,
          einID: einID.value,
          address: address.value,
          city: city.value,
          state: usState.value,
          zipCode: zipCode.value,
        );

        _companyID = newCompany.id;
        companies.addItem(newCompany.name);
        emitSuccess(
          canSubmitAgain: true,
        );
      } catch (e) {
        emitFailure(failureResponse: e.toString());
      }
    } else if (havingCompany.value == 'Yes') {
      _companyID = companiesRepository.getCompanyID(companies.value);
      if (_companyID != -1) {
        emitSuccess(
          canSubmitAgain: true,
        );
      } else {
        emitFailure(failureResponse: 'Server Internal Error');
      }
    }
  }

  @override
  Future<void> onLoading() async {
    try {
      var newCompanies = await companiesRepository.loadCompanyNames();
      companies.clear();
      for (var item in newCompanies) {
        companies.addItem(item);
      }
      emitLoaded();
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }
  }

  String getCompanyID() {
    return _companyID;
  }
}

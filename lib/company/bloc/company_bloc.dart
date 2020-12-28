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
        emitFailure();
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

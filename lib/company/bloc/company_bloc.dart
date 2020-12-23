import 'package:fe/company/company.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:meta/meta.dart';

class CompanyBloc extends FormBloc<String, String> {
  CompanyBloc({
    @required this.companiesRepository,
  }) {
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
    validators: [FieldBlocValidators.required],
    items: ['Yes', 'No'],
  );

  final companies = SelectFieldBloc();

  final name = TextFieldBloc();

  final fedID = TextFieldBloc();
  final einID = TextFieldBloc();

  final address = TextFieldBloc();

  final city = TextFieldBloc();

  final usState = SelectFieldBloc(
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

  final zipCode = TextFieldBloc();

  @override
  void onSubmitting() async {
    var newCompany = await companiesRepository.signUp(
      name: name.value,
      fedID: fedID.value,
      einID: einID.value,
      address: address.value,
      city: city.value,
      state: usState.value,
      zipCode: zipCode.value,
    );

    if (newCompany != null) {
      companies.addItem(newCompany.name);
      emitSuccess(
        canSubmitAgain: true,
      );
    } else {
      emitFailure();
    }
  }

  @override
  Future<void> onLoading() async {
    companies.clear();
    var newCompanies = await companiesRepository.loadCompanyNames();
    for (var item in newCompanies) {
      companies.addItem(item);
    }
    emitLoaded();
  }

  String getCoompanyID() {
    return companiesRepository.getCompanyID(name.value);
  }
}

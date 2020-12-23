import 'package:fe/address/address.dart';
import 'package:fe/cart/view/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class AddressFormBloc extends FormBloc<String, String> {
  AddressFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        address,
        city,
        usState,
        zipCode,
      ],
    );
  }

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
    emitSuccess();
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddressFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<AddressFormBloc>(context);
          return FormBlocListener<AddressFormBloc, String, String>(
            onSuccess: (context, state) {
              final address = Address(
                address: formBloc.address.value,
                city: formBloc.city.value,
                state: formBloc.usState.value,
                zipcode: formBloc.zipCode.value,
              );
              context.read<CartFormBloc>().addresses.addItem(address.address);
              Navigator.of(context).pushNamed('/cart');
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFieldBlocBuilder(
                      textFieldBloc: formBloc.address,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        prefixIcon: Icon(Icons.sentiment_very_satisfied),
                      ),
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: formBloc.city,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'City',
                        prefixIcon: Icon(Icons.sentiment_very_satisfied),
                      ),
                    ),
                    DropdownFieldBlocBuilder(
                      selectFieldBloc: formBloc.usState,
                      itemBuilder: (context, value) => value,
                      decoration: InputDecoration(
                          labelText: 'State',
                          prefixIcon: Icon(Icons.sentiment_satisfied)),
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: formBloc.zipCode,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'ZipCode',
                        prefixIcon: Icon(Icons.sentiment_very_satisfied),
                      ),
                    ),
                    RaisedButton(
                      onPressed: formBloc.submit,
                      child: Text('Add'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

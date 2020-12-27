import 'package:fe/address/address.dart';
import 'package:fe/address/bloc/address_bloc.dart';
import 'package:fe/cart/view/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddressBloc(
          addressesRepository:
              RepositoryProvider.of<AddressesRepository>(context)),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<AddressBloc>(context);
          return FormBlocListener<AddressBloc, String, String>(
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
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        prefixIcon: Icon(Icons.sentiment_very_satisfied),
                      ),
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: formBloc.city,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        prefixIcon: Icon(Icons.sentiment_very_satisfied),
                      ),
                    ),
                    DropdownFieldBlocBuilder(
                      selectFieldBloc: formBloc.usState,
                      itemBuilder: (context, value) => value,
                      decoration: const InputDecoration(
                          labelText: 'State',
                          prefixIcon: Icon(Icons.sentiment_satisfied)),
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: formBloc.zipCode,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'ZipCode',
                        prefixIcon: Icon(Icons.sentiment_very_satisfied),
                      ),
                    ),
                    RaisedButton(
                      onPressed: formBloc.submit,
                      child: const Text('Add'),
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

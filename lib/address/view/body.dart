import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/address/address.dart';
import 'package:fe/address/bloc/address_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddressBloc(
          addressesRepository:
              RepositoryProvider.of<AddressesRepository>(context),
          authenticationRepository:
              RepositoryProvider.of<AuthenticationRepository>(context)),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<AddressBloc>(context);
          return FormBlocListener<AddressBloc, String, String>(
            onSuccess: (context, state) {
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

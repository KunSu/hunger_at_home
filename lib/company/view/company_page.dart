import 'package:fe/company/company.dart';
import 'package:fe/register/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class CompanyPage extends StatelessWidget {
  static String routeName = '/company';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Company')),
      body: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<CompanyBloc>(context);

          return FormBlocListener<CompanyBloc, String, String>(
            onSuccess: (context, state) {
              Navigator.pushNamed(
                context,
                RegisterPage.routeName,
                arguments: CompanyIDArguments(
                  companyID: formBloc.getCompanyID(),
                ),
              );
            },
            onFailure: (context, state) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.failureResponse),
                ),
              );
            },
            child: const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CompanyForm(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CompanyForm extends StatelessWidget {
  const CompanyForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<CompanyBloc>(context);
    // formBloc.onLoading();
    return Column(
      children: <Widget>[
        RadioButtonGroupFieldBlocBuilder(
          selectFieldBloc: formBloc.havingCompany,
          itemBuilder: (context, value) => value,
          decoration: const InputDecoration(
            labelText: 'Having an existing company?',
            prefixIcon: SizedBox(),
          ),
        ),
        DropdownFieldBlocBuilder(
          selectFieldBloc: formBloc.companies,
          itemBuilder: (context, value) => value,
          decoration: const InputDecoration(
              labelText: 'Companies',
              prefixIcon: Icon(Icons.sentiment_satisfied)),
        ),
        TextFieldBlocBuilder(
          textFieldBloc: formBloc.name,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: 'Company Name',
            prefixIcon: Icon(Icons.sentiment_very_satisfied),
          ),
        ),
        TextFieldBlocBuilder(
          textFieldBloc: formBloc.fedID,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: '501c3 FED ID',
            prefixIcon: Icon(Icons.sentiment_very_satisfied),
          ),
        ),
        TextFieldBlocBuilder(
          textFieldBloc: formBloc.einID,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: 'EIN ID',
            prefixIcon: Icon(Icons.sentiment_very_satisfied),
          ),
        ),
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
              labelText: 'State', prefixIcon: Icon(Icons.sentiment_satisfied)),
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
          child: const Text('Register'),
        ),
      ],
    );
  }
}

class CompanyIDArguments {
  CompanyIDArguments({this.companyID});

  final String companyID;
}

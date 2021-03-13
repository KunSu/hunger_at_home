import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/view/display_error.dart';
import 'package:fe/components/view/my_circularprogress_indicator.dart';
import 'package:fe/reference/reference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class ReferencePage extends StatelessWidget {
  const ReferencePage({Key key}) : super(key: key);
  static String routeName = '/reference';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reference'),
      ),
      body: RepositoryProvider(
        create: (context) => ReferencesRepository(),
        child: BlocProvider(
          create: (context) => ReferenceBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context),
              referencesRepository:
                  RepositoryProvider.of<ReferencesRepository>(context)),
          child: Builder(
            builder: (context) {
              final formBloc = RepositoryProvider.of<ReferenceBloc>(context);
              return FormBlocListener<ReferenceBloc, String, String>(
                onSuccess: (context, state) {},
                onFailure: (context, state) {
                  displayError(
                    context: context,
                    error: state.failureResponse,
                  );
                },
                child: BlocBuilder<ReferenceBloc, FormBlocState>(
                  builder: (context, state) {
                    if (state is FormBlocLoaded) {
                      return ReferenceView(formBloc: formBloc);
                    } else {
                      if (state is FormBlocFailure) {
                        formBloc.emitLoaded();
                      }
                      return const MyCircularProgressIndicator();
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ReferenceView extends StatelessWidget {
  const ReferenceView({
    Key key,
    @required this.formBloc,
  }) : super(key: key);

  final ReferenceBloc formBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CheckboxGroupFieldBlocBuilder(
            multiSelectFieldBloc: formBloc.references,
            itemBuilder: (context, value) => value,
            decoration: const InputDecoration(
              labelText: 'Reference',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back'),
              ),
              const SizedBox(width: 10),
              RaisedButton(
                onPressed: formBloc.submit,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

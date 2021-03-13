import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/reference/reference.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:meta/meta.dart';

class ReferenceBloc extends FormBloc<String, String> {
  ReferenceBloc({
    @required this.authenticationRepository,
    @required this.referencesRepository,
  }) : super(isLoading: true) {
    addFieldBlocs(
      fieldBlocs: [
        references,
      ],
    );
  }

  final AuthenticationRepository authenticationRepository;
  final ReferencesRepository referencesRepository;

  final references = MultiSelectFieldBloc<String, dynamic>(
    items: [
      'fruit',
      'veggies',
      'meat',
      'seafood',
      'dry',
      'others',
    ],
  );

  @override
  Future<void> onLoading() async {
    super.onLoading();

    try {
      final userID = authenticationRepository.user.id;
      var defaultReferences = <String>[];
      await referencesRepository
          .getReference(userID: userID)
          .then((values) => (defaultReferences = values));
      references.updateInitialValue(defaultReferences);
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }

    emitLoaded();
  }

  @override
  Future<void> onSubmitting() async {
    try {
      await referencesRepository
          .updateReference(
            userID: authenticationRepository.user.id,
            newReferences: references.value,
          )
          .then(references.updateInitialValue);
      emitSuccess(
        canSubmitAgain: true,
      );
      emitLoaded();
    } catch (e) {
      emitFailure(failureResponse: e.toString());
      return;
    }
  }
}

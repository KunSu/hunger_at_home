import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:http/http.dart';

class ResetPasswordBloc extends FormBloc<String, String> {
  ResetPasswordBloc() {
    addFieldBlocs(
      fieldBlocs: [
        email,
      ],
    );
  }

  final email = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.email,
    ],
  );

  @override
  Future<void> onSubmitting() async {
    try {
      var url = '${env['BASE_URL']}/sendEmail/${email.value}';
      print(url);

      var headers = <String, String>{'Content-type': 'application/json'};

      var response = await get(url, headers: headers);

      var body = json.decode(response.body);
      if (response.statusCode == 200) {
        emitSuccess(
          successResponse: body['message'],
          canSubmitAgain: true,
        );
      } else {
        emitFailure(failureResponse: body['message']);
      }
    } catch (e) {
      emitFailure(failureResponse: 'unknown error occur');
    }
    emitLoaded();
  }
}

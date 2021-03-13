import 'dart:convert';
import 'dart:core';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

class ReferencesRepository {
  ReferencesRepository() {
    references = <String>[];
  }
  List<String> references;

  Future<List<String>> getReference({@required String userID}) async {
    final url = '${env['BASE_URL']}/users/$userID/reference';

    print(url);
    var response = await get(url);

    final body = json.decode(response.body);

    if (response.statusCode == 200) {
      references
        ..clear()
        ..addAll(body['category'].cast<String>());

      return references;
    } else {
      throw body['message'];
    }
  }

  Future<List<String>> updateReference(
      {@required String userID, @required List<String> references}) async {
    var url =
        '${env['BASE_URL']}/users/$userID/reference?category=${references.join(',')}';
    print(url);

    var headers = <String, String>{'Content-type': 'application/json'};

    var response = await patch(url, headers: headers);

    var body = json.decode(response.body);
    if (response.statusCode == 200) {
      references
        ..clear()
        ..addAll(body['category'].cast<String>());
      return references;
    } else {
      throw (body['message']);
    }
  }
}

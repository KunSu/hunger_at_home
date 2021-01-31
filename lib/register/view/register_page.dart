import 'package:fe/company/company.dart';
import 'package:flutter/material.dart';

import 'body.dart';

class RegisterPage extends StatelessWidget {
  static String routeName = '/register';

  @override
  Widget build(BuildContext context) {
    CompanyIDArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Body(companyID: args.companyID),
    );
  }
}

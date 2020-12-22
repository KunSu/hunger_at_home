import 'package:fe/components/view/background.dart';
import 'package:fe/register/view/register_form.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({Key key, this.companyID}) : super(key: key);

  final String companyID;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Background(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/food_logo.png',
            height: size.height * 0.2,
          ),
          // SizedBox(height: size.height * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/landing_logo.png',
                height: size.height * 0.05,
              ),
              Column(
                children: <Widget>[
                  const Text(
                    'Welcome Back',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Login with your account',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          // SizedBox(height: size.height * 0.03),
          RegisterForm(companyID: companyID),
        ],
      ),
    ));
  }
}

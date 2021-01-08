import 'package:fe/company/company.dart';
import 'package:fe/components/constants.dart';
import 'package:fe/components/view/background.dart';
import 'package:fe/components/view/rounded_botton.dart';
import 'package:fe/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Background(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: size.height * 0.1),
        Image.asset(
          'assets/images/landing_logo.png',
          height: size.height * 0.3,
        ),
        const Text('Welcome to',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        const Text('Hunger At Home',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        SizedBox(height: size.height * 0.05),
        RoundedButton(
          text: 'Log In',
          textColor: Colors.white,
          press: () {
            Navigator.pushNamed(context, LoginPage.routeName);
          },
        ),
        RoundedButton(
          text: 'Register',
          color: kPrimaryColor,
          press: () {
            Navigator.pushNamed(context, CompanyPage.routeName);
          },
        ),
        Expanded(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Copyright @ 2021 SJSU',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}

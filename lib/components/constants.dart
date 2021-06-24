import 'package:flutter/material.dart';

const kPrimaryColor = Colors.blue;
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kBlackColor = Color(0xFF393939);
const kLightBlackColor = Color(0xFF8F8F8F);

const kAnimationDuration = Duration(milliseconds: 200);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
const String kEmailNullError = 'Please Enter your email';
const String kInvalidEmailError = 'Please Enter Valid Email';
const String kPassNullError = 'Please Enter your password';
const String kShortPassError = 'Password is too short';
const String kMatchPassError = "Passwords don't match";

// Color
const hahBorderBlue = Color(0xFF0a64c8);
const hahBlue = Color(0xFF37b4eb);
const hahSkyBlue = Color(0xFFc3ebff);
const hahRed = Color(0xFFd72328);

const hungerAtHomePhoneNumber = 4083180038;
const hungerAtHomeAddress = '1560 Berger Dr, San Jose, CA 95112';

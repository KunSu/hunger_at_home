import 'package:fe/address/address.dart';
import 'package:fe/donor/view/donor_page.dart';
import 'package:fe/employee/view/employee_page.dart';
import 'package:fe/login/view/login_page.dart';
import 'package:fe/register/view/register_page.dart';
import 'package:fe/welcome/view/welcome_page.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  WelcomePage.routeName: (context) => WelcomePage(),
  LoginPage.routeName: (context) => LoginPage(),
  RegisterPage.routeName: (context) => RegisterPage(),
  DonorPage.routeName: (context) => DonorPage(),
  EmployeePage.routeName: (context) => EmployeePage(),
  AddressPage.routeName: (context) => AddressPage(),
};

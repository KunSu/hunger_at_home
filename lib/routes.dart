import 'package:fe/address/address.dart';
import 'package:fe/admin/view/admin_page.dart';
import 'package:fe/cart/view/cart_page.dart';
import 'package:fe/company/view/view.dart';
import 'package:fe/item/item.dart';
import 'package:fe/donor/view/donor_page.dart';
import 'package:fe/employee/view/employee_page.dart';
import 'package:fe/login/view/login_page.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_detail/view/order_detail_page.dart';
import 'package:fe/pantry/view/pantry_page.dart';
import 'package:fe/recipient/view/recipient_page.dart';
import 'package:fe/register/view/register_page.dart';
import 'package:fe/welcome/view/welcome_page.dart';
import 'package:flutter/material.dart';

import 'account/view/account_page.dart';
import 'order_delivery/view/order_delivery_page.dart';
import 'order_pickup/view/order_pickup_page.dart';

final Map<String, WidgetBuilder> routes = {
  WelcomePage.routeName: (context) => WelcomePage(),
  LoginPage.routeName: (context) => LoginPage(),
  RegisterPage.routeName: (context) => RegisterPage(),
  DonorPage.routeName: (context) => DonorPage(),
  EmployeePage.routeName: (context) => EmployeePage(),
  RecipientPage.routeName: (context) => RecipientPage(),
  AdminPage.routeName: (context) => AdminPage(),
  PantryPage.routeName: (context) => PantryPage(),
  CartPage.routeName: (context) => CartPage(),
  ItemPage.routeName: (context) => ItemPage(),
  OrderPage.routeName: (context) => OrderPage(),
  AddressPage.routeName: (context) => AddressPage(),
  OrderDetailPage.routeName: (context) => OrderDetailPage(),
  CompanyPage.routeName: (context) => CompanyPage(),
  AccountPage.routeName: (context) => AccountPage(),
  OrderPickupPage.routeName: (context) => OrderPickupPage(),
  OrderDeliveryPage.routeName: (context) => OrderDeliveryPage(),
};

import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/admin_order/view/admin_order_page.dart';
import 'package:fe/authentication/authentication.dart';
import 'package:fe/components/models/screen_arguments.dart';
import 'package:fe/components/view/buttom_navigation_bar.dart';
import 'package:fe/components/view/buttom_navigation_bar_v2.dart';
import 'package:fe/item/view/view.dart';
import 'package:fe/order/view/order_page.dart';
import 'package:fe/order_summary/view/view.dart';
import 'package:fe/pending_registraion/view/pending_registraion_page.dart';
import 'package:fe/reference/reference.dart';
import 'package:fe/reset_password/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPage extends StatelessWidget {
  static String routeName = '/account';

  @override
  Widget build(BuildContext context) {
    final identity = RepositoryProvider.of<AuthenticationRepository>(context)
        .user
        .userIdentity;
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: Column(
        children: <Widget>[
          Visibility(
            visible: identity != 'admin',
            child: ListTile(
              title: const Text(
                'Your Orders',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  OrderPage.routeName,
                );
              },
            ),
          ),
          ListTile(
            title: const Text(
              'Reset Password',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                ResetPasswordPage.routeName,
              );
            },
          ),
          Visibility(
            visible: identity == 'admin',
            child: ListTile(
              title: const Text('Donation offers',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 18,
                  )),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AdminOrderPage.routeName,
                  arguments: ScreenArguments(
                    screenTitle: 'Donation offers',
                    orderType: <String>{'donation', 'dropoff', 'anonymous'},
                    status: <String>{'all'},
                  ),
                );
              },
            ),
          ),
          Visibility(
            visible: identity == 'admin',
            child: ListTile(
              title: const Text('Request orders',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 18,
                  )),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AdminOrderPage.routeName,
                  arguments: ScreenArguments(
                    screenTitle: 'Request orders',
                    orderType: <String>{'request'},
                    status: <String>{'all'},
                  ),
                );
              },
            ),
          ),
          Visibility(
            visible: identity == 'admin',
            child: ListTile(
              title: const Text('Driver orders',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 18,
                  )),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AdminOrderPage.routeName,
                  arguments: ScreenArguments(
                    screenTitle: 'Driver orders',
                    orderType: <String>{'donation'},
                    status: <String>{
                      'approved',
                      'confirmed',
                      'pickedup',
                      'delivered',
                      'cancelled',
                    },
                  ),
                );
              },
            ),
          ),
          Visibility(
            visible: identity == 'admin',
            child: ListTile(
              title: const Text('Pending registration',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 18,
                  )),
              onTap: () {
                Navigator.pushNamed(context, PendingRegistrationPage.routeName);
              },
            ),
          ),
          Visibility(
            visible: identity == 'admin',
            child: ListTile(
              title: const Text('Create anonymous order',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 18,
                  )),
              onTap: () {
                Navigator.pushNamed(context, ItemPage.routeName);
              },
            ),
          ),
          Visibility(
            visible: identity == 'admin',
            child: ListTile(
              title: const Text('Order Summary',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 18,
                  )),
              onTap: () {
                Navigator.pushNamed(context, OrderSummaryPage.routeName);
              },
            ),
          ),
          Visibility(
            visible: identity == 'recipient',
            child: ListTile(
              title: const Text('Reference',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 18,
                  )),
              onTap: () {
                Navigator.pushNamed(context, ReferencePage.routeName);
              },
            ),
          ),
          ListTile(
            title: const Text('Log Out',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 18,
                )),
            onTap: () {
              context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested());
            },
          ),
        ],
      ),
      bottomNavigationBar: identity == 'donor' || identity == 'recipient'
          ? MyBottomNavigationBar(
              identity: RepositoryProvider.of<AuthenticationRepository>(context)
                  .user
                  .userIdentity,
            )
          : MyBottomNavigationBarV2(
              identity: RepositoryProvider.of<AuthenticationRepository>(context)
                  .user
                  .userIdentity,
            ),
    );
  }
}

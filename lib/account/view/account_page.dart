import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/admin_order/view/admin_order_page.dart';
import 'package:fe/authentication/authentication.dart';
import 'package:fe/components/models/screen_arguments.dart';
import 'package:fe/components/view/buttom_navigation_bar.dart';
import 'package:fe/components/view/buttom_navigation_bar_v2.dart';
import 'package:fe/order/view/order_page.dart';
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
              title: const Text('Your Orders',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 18,
                  )),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  OrderPage.routeName,
                  // arguments: ScreenArguments(
                  //   screenTitle: 'Orders',
                  //   status: ' ',
                  // ),
                );
              },
            ),
          ),
          Visibility(
            visible: identity == 'admin',
            child: ListTile(
              title: const Text('Donation orders',
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
                    screenTitle: 'Donation orders',
                    orderType: 'donation',
                    status: ' ',
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
                    orderType: 'request',
                    status: ' ',
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
                    orderType: 'donation',
                    status: ' ',
                  ),
                );
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
                  .bloc<AuthenticationBloc>()
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

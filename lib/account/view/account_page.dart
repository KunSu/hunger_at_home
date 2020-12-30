import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/authentication/authentication.dart';
import 'package:fe/components/view/buttom_navigation_bar.dart';
import 'package:fe/order/view/order_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPage extends StatelessWidget {
  static String routeName = '/account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: Column(
        children: <Widget>[
          ListTile(
            title: const Text('Your Orders',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 18,
                )),
            onTap: () {
              Navigator.pushNamed(context, OrderPage.routeName);
            },
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
      bottomNavigationBar: MyBottomNavigationBar(
        identity: RepositoryProvider.of<AuthenticationRepository>(context)
            .user
            .userIdentity,
      ),
    );
  }
}

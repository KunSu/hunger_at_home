import 'package:fe/account/account.dart';
import 'package:fe/admin/view/admin_page.dart';
import 'package:fe/donor/donor.dart';
import 'package:fe/employee/view/employee_page.dart';
import 'package:fe/item/view/item_page.dart';
import 'package:fe/recipient/view/recipient_page.dart';
import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatefulWidget {
  MyBottomNavigationBar({
    Key key,
    @required this.identity,
  }) : super(key: key);
  final String identity;

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState(
        identity: identity,
      );
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  _MyBottomNavigationBarState({
    @required this.identity,
  });

  int _selectedIndex = 0;

  final String identity;

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context).settings.name;
    switch (currentRoute) {
      case '/account':
        _selectedIndex = 1;
        break;
      case '/item':
        _selectedIndex = 2;
        break;
      default:
        _selectedIndex = 0;
        break;
    }
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Account',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.business),
          label: identity == 'donor' ? 'Donate' : 'Request',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    var _homeRouteName;
    switch (identity) {
      case 'donor':
        _homeRouteName = DonorPage.routeName;
        break;
      case 'employee':
        _homeRouteName = EmployeePage.routeName;
        break;
      case 'recipient':
        _homeRouteName = RecipientPage.routeName;
        break;
      case 'admin':
        _homeRouteName = AdminPage.routeName;
        break;
      default:
        break;
    }
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        if (ModalRoute.of(context).settings.name != _homeRouteName) {
          Navigator.pushReplacementNamed(context, _homeRouteName);
        }
      } else if (_selectedIndex == 1) {
        Navigator.pushReplacementNamed(context, AccountPage.routeName);
      } else if (_selectedIndex == 2) {
        Navigator.pushReplacementNamed(context, ItemPage.routeName);
      }
    });
  }
}

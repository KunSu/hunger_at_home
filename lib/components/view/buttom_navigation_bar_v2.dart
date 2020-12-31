import 'package:fe/account/account.dart';
import 'package:fe/approver/view/approver_page.dart';
import 'package:fe/donor/donor.dart';
import 'package:fe/employee/view/employee_page.dart';
import 'package:fe/recipient/view/recipient_page.dart';
import 'package:flutter/material.dart';

class MyBottomNavigationBarV2 extends StatefulWidget {
  MyBottomNavigationBarV2({
    Key key,
    @required this.identity,
  }) : super(key: key);
  final String identity;

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState(
        identity: identity,
      );
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBarV2> {
  _MyBottomNavigationBarState({
    @required this.identity,
  });

  int _selectedIndex = 0;

  final String identity;

  @override
  Widget build(BuildContext context) {
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
        _homeRouteName = ApproverPage.routeName;
        break;
      default:
        break;
    }
    setState(
      () {
        _selectedIndex = index;
        if (_selectedIndex == 0) {
          if (ModalRoute.of(context).settings.name != _homeRouteName) {
            Navigator.pushReplacementNamed(context, _homeRouteName);
          }
        } else if (_selectedIndex == 1) {
          Navigator.pushReplacementNamed(context, AccountPage.routeName);
        }
      },
    );
  }
}

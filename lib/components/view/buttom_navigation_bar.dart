import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatefulWidget {
  MyBottomNavigationBar(
      {Key key, @required this.homeRouteName, @required this.itemRouteName})
      : super(key: key);
  final String homeRouteName;
  final String itemRouteName;

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState(
      homeRouteName: homeRouteName, itemRouteName: itemRouteName);
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  _MyBottomNavigationBarState(
      {@required this.homeRouteName, @required this.itemRouteName});

  int _selectedIndex = 0;
  final String homeRouteName;
  final String itemRouteName;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Donate',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        if (ModalRoute.of(context).settings.name != homeRouteName) {
          Navigator.pushNamed(context, homeRouteName);
        }
      } else if (_selectedIndex == 1) {
        Navigator.pushNamed(context, itemRouteName);
      }
    });
  }
}

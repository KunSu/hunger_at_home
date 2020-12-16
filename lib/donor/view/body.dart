// import 'package:fe/Inventroy/inventroy_screen.dart';
// import 'package:fe/components/nagivator/nagivator_header.dart';
// import 'package:fe/components/item.dart';
// import 'package:fe/components/order.dart';
// import 'package:fe/size_config.dart';
// import 'package:fe/components/size_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fe/authentication/authentication.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(height: getProportionateScreenHeight(20)),
            const SizedBox(height: 20),
            // NagivatorHeader(),
            // SizedBox(height: getProportionateScreenHeight(10)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  // padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/images/Profile Image.png',
                    height: size.height * 0.1,
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'Hi, ${context.bloc<AuthenticationBloc>().state.user.username}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: size.width * 0.7,
                      child: const Text(
                        'Thanks for rescue surplus food, feed the needy, and have a positive effect on the environment.',
                        // style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('My pantry'),
                  // Item(
                  //   id: 1,
                  //   title: "Item",
                  //   name: "Apple",
                  //   number: 1,
                  //   date: "Sept 15, 2020",
                  //   quantity: "50 lbs",
                  //   press: () {
                  //     Navigator.pushNamed(context, InventroyScreen.routeName);
                  //   },
                  // ),
                  // Item(
                  //   id: 2,
                  //   title: "Item",
                  //   name: "Apple",
                  //   number: 2,
                  //   date: "Sept 15, 2020",
                  //   quantity: "50 lbs",
                  //   press: () {},
                  // ),
                  // Item(
                  //   id: 3,
                  //   title: "Item",
                  //   name: "Apple",
                  //   number: 3,
                  //   date: "Sept 15, 2020",
                  //   quantity: "50 lbs",
                  //   press: () {},
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

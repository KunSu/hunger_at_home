import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_detail/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;

Widget orderInfoView(Order order, BuildContext context) {
  return FutureBuilder<OrderDetail>(
    future: OrderDetailRepository().loadOrderDetail(
      userID: RepositoryProvider.of<AuthenticationRepository>(context).user.id,
      orderID: order.id,
    ),
    builder: (context, AsyncSnapshot<OrderDetail> snapshot) {
      if (snapshot.hasData) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Company'),
                    subtitle: Text('${snapshot.data.companyName}'),
                  ),
                  ListTile(
                    title: const Text('Order Type'),
                    subtitle: Text('${snapshot.data.orderType}'),
                  ),
                  Visibility(
                    visible: snapshot.data.orderType != 'dropoff',
                    child: ListTile(
                      title: const Text('Pick Up Date'),
                      subtitle: Text('${snapshot.data.pickupTime}'),
                    ),
                  ),
                  Visibility(
                    visible: snapshot.data.orderType == 'dropoff',
                    child: const ListTile(
                      title: Text('Drop off order'),
                    ),
                  ),
                  ListTile(
                    title: const Text('Contact Number'),
                    subtitle: FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => url_launcher
                          .launch('tel:+${snapshot.data.phoneNumber}'),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${snapshot.data.phoneNumber}',
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Address: '),
                    subtitle: FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            '${snapshot.data.address}, ${snapshot.data.city}, ${snapshot.data.state} ${snapshot.data.zipCode}'),
                      ),
                    ),
                  ),
                ],
              ),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(15),
              //   color: Colors.white,
              //   boxShadow: [
              //     const BoxShadow(color: Colors.grey, spreadRadius: 1),
              //   ],
              // ),
            ),
          ],
        );
      } else {
        return const CircularProgressIndicator();
      }
    },
  );
}

import 'package:fe/order/models/model.dart';
import 'package:fe/order/order.dart';
import 'package:flutter/material.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({
    Key key,
    @required this.order,
    @required this.snapshot,
  }) : super(key: key);

  final Order order;
  final AsyncSnapshot<dynamic> snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            title: Text('Order # ${order.id}'),
            subtitle: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  const TextSpan(
                    text: '\nCompany: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '${snapshot.data.orderType}\n',
                  ),
                  const TextSpan(
                    text: '\nCompany: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '${snapshot.data.companyName}\n',
                  ),
                  const TextSpan(
                    text: '\nPick Up Date: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '${snapshot.data.pickupTime}\n',
                  ),
                  const TextSpan(
                    text: '\nContact Number: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    // TODO: Phone Number is callable
                    text: '${snapshot.data.phoneNumber}\n',
                  ),
                  const TextSpan(
                    text: '\nAddress: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        '${snapshot.data.address}, ${snapshot.data.city}, ${snapshot.data.state} ${snapshot.data.zipCode}\n',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          const BoxShadow(color: Colors.grey, spreadRadius: 1),
        ],
      ),
    );
  }
}

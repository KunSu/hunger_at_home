import 'package:fe/order_summary/order_summary.dart';
import 'package:flutter/material.dart';

class OrderSummaryPage extends StatelessWidget {
  const OrderSummaryPage({
    Key key,
  }) : super(key: key);
  static String routeName = '/order_summary';

  @override
  Widget build(BuildContext context) {
    var type = <String>{'all'};
    var status = <String>{'all'};
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order Summary'),
          bottom: const TabBar(
            labelPadding: EdgeInsets.all(8.0),
            labelStyle: TextStyle(fontSize: 20.0),
            tabs: [
              Text('Order View'),
              Text('Item View'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrderSummaryView(viewType: 'order', type: type, status: status),
            OrderSummaryView(viewType: 'item', type: type, status: status),
          ],
        ),
      ),
    );
  }
}

class OrderSummaryView extends StatelessWidget {
  const OrderSummaryView({
    Key key,
    @required this.viewType,
    @required this.type,
    @required this.status,
  }) : super(key: key);
  final String viewType;
  final Set<String> type;
  final Set<String> status;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const OrderSummaryForm(),
          Expanded(
            child: OrderSummaryOrderList(
                viewType: viewType, orderType: type, status: status),
          ),
        ],
      ),
    );
  }
}

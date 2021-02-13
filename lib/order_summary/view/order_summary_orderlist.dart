import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_summary/order_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderSummaryOrderList extends StatefulWidget {
  const OrderSummaryOrderList({
    Key key,
    this.viewType,
    this.orderType,
    this.status,
  }) : super(key: key);
  final String viewType;
  final Set<String> orderType;
  final Set<String> status;

  @override
  _OrderSummaryOrderListState createState() => _OrderSummaryOrderListState(
      viewType: viewType, orderType: orderType, status: status);
}

class _OrderSummaryOrderListState extends State<OrderSummaryOrderList> {
  _OrderSummaryOrderListState({this.viewType, this.orderType, this.status});
  final Set<String> orderType;
  final Set<String> status;
  final String viewType;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    // Default load previous one week orders for order summary
    context.read<OrdersBloc>().add(OrderLoadSummary(
          userID:
              RepositoryProvider.of<AuthenticationRepository>(context).user.id,
          startDate: DateTime.now()
              .subtract(const Duration(days: 7))
              .toUtc()
              .toIso8601String(),
          endDate: DateTime.now().toUtc().toIso8601String(),
          type: <String>{'all'},
          status: <String>{'all'},
          download: false,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state is OrdersLoadFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
            ),
          );
        }
      },
      child: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoadInProgress) {
            return const CircularProgressIndicator();
          }
          if (state is OrdersLoadSuccess) {
            if (state.orders == null || state.orders.isEmpty) {
              return const Text('You do not have any order yet');
            }
            if (viewType == 'order') {
              return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) => Visibility(
                  visible: getOrderVisibility(
                      order: state.orders[index],
                      orderType: orderType,
                      status: status),
                  child: OrderSummaryOrderView(order: state.orders[index]),
                ),
              );
            } else if (viewType == 'item') {
              return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) => Visibility(
                  visible: getOrderVisibility(
                      order: state.orders[index],
                      orderType: orderType,
                      status: status),
                  child: OrderSummaryItemView(order: state.orders[index]),
                ),
              );
            } else {
              return const Center(child: Text('Something went wrong'));
            }
          }
          if (state is OrdersLoadFailure) {
            return Text(state.error.toString());
          }
          return const Text('Something went wrong');
        },
      ),
    );
  }

  bool getOrderVisibility({
    @required Order order,
    @required Set<String> orderType,
    @required Set<String> status,
  }) {
    if ((orderType.contains('all') || orderType.contains(order.type)) &&
        (status.contains('all') || status.contains(order.status))) return true;
    return false;
  }
}

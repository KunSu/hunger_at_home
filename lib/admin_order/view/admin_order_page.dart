import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/admin_order/view/admin_order_action_view.dart';
import 'package:fe/components/models/screen_arguments.dart';
import 'package:fe/order/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminOrderPage extends StatelessWidget {
  const AdminOrderPage({
    Key key,
  }) : super(key: key);
  static String routeName = '/admin_order';

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    final screenTitle = args.screenTitle;
    final orderType = args.orderType;
    final status = args.status;

    return Scaffold(
      appBar: AppBar(title: Text(screenTitle)),
      // TODO: init OrdersRepository right here
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: AdminOrderActionList(
                orderType: orderType,
                status: status,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminOrderActionList extends StatefulWidget {
  const AdminOrderActionList({
    Key key,
    this.orderType,
    this.status,
  }) : super(key: key);
  final Set<String> orderType;
  final Set<String> status;

  @override
  _AdminOrderActionListState createState() =>
      _AdminOrderActionListState(orderType: orderType, status: status);
}

class _AdminOrderActionListState extends State<AdminOrderActionList> {
  _AdminOrderActionListState({this.orderType, this.status});
  final Set<String> orderType;
  final Set<String> status;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await RepositoryProvider.of<OrdersRepository>(context).loadOrdersByAdmin(
        userID:
            RepositoryProvider.of<AuthenticationRepository>(context).user.id,
        orderType: <String>{'all'},
        status: status);
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<List<Order>>(
    //   future:
    //       RepositoryProvider.of<OrdersRepository>(context).loadOrdersByAdmin(
    //     userID:
    //         RepositoryProvider.of<AuthenticationRepository>(context).user.id,
    //     orderType: orderType,
    //     status: status,
    //   ),
    //   builder: (context, AsyncSnapshot<List<Order>> snapshot) {
    //     if (snapshot.hasData) {
    //       return ListView.builder(
    //         itemCount: snapshot.data.length,
    //         itemBuilder: (context, index) =>
    //             AdminOrderActionView(order: snapshot.data[index]),
    //       );
    //     } else if (snapshot.hasError) {
    //       return Text(snapshot.error);
    //     } else {
    //       return const CircularProgressIndicator();
    //     }
    //   },
    // );

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
            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) => Visibility(
                visible: getOrderVisibility(
                    order: state.orders[index],
                    orderType: orderType,
                    status: status),
                child: AdminOrderActionView(order: state.orders[index]),
              ),
            );
          }
          if (state is OrdersLoadFailure) {
            // return FutureBuilder<List<Order>>(
            //   future: RepositoryProvider.of<OrdersRepository>(context)
            //       .loadOrdersByAdmin(
            //     userID: RepositoryProvider.of<AuthenticationRepository>(context)
            //         .user
            //         .id,
            //     orderType: widget.orderType,
            //     status: widget.status,
            //   ),
            //   builder: (context, AsyncSnapshot<List<Order>> snapshot) {
            //     if (snapshot.hasData) {
            //       return ListView.builder(
            //         itemCount: snapshot.data.length,
            //         itemBuilder: (context, index) =>
            //             AdminOrderActionView(order: snapshot.data[index]),
            //       );
            //     } else if (snapshot.hasError) {
            //       return Text(snapshot.error.toString());
            //     } else {
            //       return const CircularProgressIndicator();
            //     }
            //   },
            // );
            // return const Text('OrdersLoadFailure');
            // TODO: better handle error
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

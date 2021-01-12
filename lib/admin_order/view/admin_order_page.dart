import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/models/screen_arguments.dart';
import 'package:fe/components/view/contact_dialog.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_delivery/view/order_delivery_page.dart';
import 'package:fe/order_detail/order_detail.dart';
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
  final String orderType;
  final Set<String> status;

  @override
  _AdminOrderActionListState createState() =>
      _AdminOrderActionListState(orderType: orderType, status: status);
}

class _AdminOrderActionListState extends State<AdminOrderActionList> {
  _AdminOrderActionListState({this.orderType, this.status});
  final String orderType;
  final Set<String> status;

  @override
  void didChangeDependencies() {
    RepositoryProvider.of<OrdersRepository>(context).loadOrdersByAdmin(
        userID:
            RepositoryProvider.of<AuthenticationRepository>(context).user.id,
        orderType: orderType,
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
              itemBuilder: (context, index) =>
                  AdminOrderActionView(order: state.orders[index]),
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
            return const Text('OrdersLoadFailure');
          }
          return const Text('Something went wrong');
        },
      ),
    );
  }
}

class AdminOrderActionView extends StatefulWidget {
  const AdminOrderActionView({Key key, this.order}) : super(key: key);
  final Order order;

  @override
  _AdminOrderActionViewState createState() => _AdminOrderActionViewState();
}

class _AdminOrderActionViewState extends State<AdminOrderActionView> {
  @override
  Widget build(BuildContext context) {
    final identity = RepositoryProvider.of<AuthenticationRepository>(context)
        .user
        .userIdentity;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Order #: ${widget.order.id}'),
            subtitle: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Order date: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '${widget.order.submitedDateAndTime}\n',
                  ),
                  const TextSpan(
                    text: 'Address: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '${widget.order.address}\n',
                  ),
                  const TextSpan(
                    text: 'Pick up date: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '${widget.order.pickupDateAndTime}\n',
                  ),
                  TextSpan(
                    text: 'Status: ${widget.order.status}\n',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text('Detail'),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    OrderDetailPage.routeName,
                    arguments: ScreenArguments(order: widget.order),
                  );
                },
              ),
              TextButton(
                child: const Text('Contact'),
                onPressed: () {
                  ContactDialog(
                    context: context,
                    order: widget.order,
                  );
                },
              ),
              Visibility(
                visible:
                    widget.order.status == 'pending' && identity == 'admin',
                child: TextButton(
                  child: const Text('Approve'),
                  onPressed: () {
                    var newOrder = widget.order.copyWith(status: 'approved');
                    BlocProvider.of<OrdersBloc>(context)
                        .add(OrderUpdated(newOrder));
                  },
                ),
              ),
              Visibility(
                visible: widget.order.status == 'pending',
                child: TextButton(
                  child: const Text('Withdraw'),
                  onPressed: () {
                    OrderUpdateDialog(
                        context: context,
                        order: widget.order,
                        text:
                            'Please confirm if you want to withdraw the order.',
                        title: 'Confirmation',
                        status: 'withdraw');
                  },
                ),
              ),
              Visibility(
                visible: widget.order.status == 'approved' &&
                    (identity == 'recipient' || identity == 'admin'),
                child: TextButton(
                  child: const Text('Receive'),
                  onPressed: () {
                    OrderUpdateDialog(
                        context: context,
                        order: widget.order,
                        text: 'Please confirm if you have received the order.',
                        title: 'Confirmation',
                        status: 'received');
                  },
                ),
              ),
              Visibility(
                visible: widget.order.status == 'approved' &&
                    (identity == 'employee' || identity == 'admin'),
                child: TextButton(
                  child: const Text('Pick up'),
                  onPressed: () {
                    if (identity == 'admin') {
                      OrderUpdateDialog(
                          context: context,
                          order: widget.order,
                          text:
                              'Please confirm if you have pickuped the order.',
                          title: 'Confirmation',
                          status: 'pickuped');
                    } else {
                      Navigator.pushNamed(
                        context,
                        OrderDeliveryPage.routeName,
                        arguments: ScreenArguments(order: widget.order),
                      );
                    }
                  },
                ),
              ),
              Visibility(
                visible: widget.order.status == 'pickuped' &&
                    (identity == 'employee' || identity == 'admin'),
                child: TextButton(
                  child: const Text('Deliver'),
                  onPressed: () {
                    if (identity == 'admin') {
                      OrderUpdateDialog(
                          context: context,
                          order: widget.order,
                          text:
                              'Please confirm if you have delivered the order.',
                          title: 'Confirmation',
                          status: 'delivered');
                    } else {
                      Navigator.pushNamed(
                        context,
                        OrderDeliveryPage.routeName,
                        arguments: ScreenArguments(order: widget.order),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> OrderUpdateDialog({
  @required BuildContext context,
  @required Order order,
  @required String title,
  @required String text,
  @required String status,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(text),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              var newOrder = order.copyWith(status: status);
              Navigator.of(context).pop();
              BlocProvider.of<OrdersBloc>(context).add(OrderUpdated(newOrder));
            },
          ),
        ],
      );
    },
  );
}
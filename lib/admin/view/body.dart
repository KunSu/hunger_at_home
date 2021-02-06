import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/models/screen_arguments.dart';
import 'package:fe/components/view/user_info.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_detail/view/order_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const UserInfo(),
          const Text('Donation orders'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: _AdminOrderList(
                  orderType: <String>{'donation,dropoff,anonymous'}),
            ),
          ),
          const Text('Request orders'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: _AdminOrderList(orderType: <String>{'request'}),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminOrderList extends StatelessWidget {
  _AdminOrderList({Key key, this.orderType}) : super(key: key);
  final Set<String> orderType;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future:
          RepositoryProvider.of<OrdersRepository>(context).loadOrdersByAdmin(
        userID:
            RepositoryProvider.of<AuthenticationRepository>(context).user.id,
        orderType: orderType,
        status: <String>{'all'},
      ),
      builder: (context, AsyncSnapshot<List<Order>> snapshot) {
        // TODO: Add pull to refresh
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.hasData) {
          if (snapshot.data == null || snapshot.data.isEmpty) {
            return const Text('You do not have any order yet');
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) =>
                _AdminOrderView(order: snapshot.data[index]),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
    //        return BlocListener<OrdersBloc, OrdersState>(
    //   listener: (context, state) {
    //     if (state is OrdersLoadFailure) {
    //       Scaffold.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text(state.error),
    //         ),
    //       );
    //     }
    //   },
    //   child: BlocBuilder<OrdersBloc, OrdersState>(
    //     builder: (context, state) {
    //       if (state is OrdersLoadInProgress) {
    //         return const CircularProgressIndicator();
    //       }
    //       if (state is OrdersLoadSuccess) {
    //         if (state.orders == null || state.orders.isEmpty) {
    //           return const Text('You do not have any order yet');
    //         }
    //         return ListView.builder(
    //           itemCount: state.orders.length,
    //           itemBuilder: (context, index) =>
    //               _AdminOrderView(order: state.orders[index]),
    //         );
    //       }
    //       if (state is OrdersLoadFailure) {
    //         return FutureBuilder<List<Order>>(
    //           future: RepositoryProvider.of<OrdersRepository>(context)
    //               .loadOrdersByAdmin(
    //             userID: RepositoryProvider.of<AuthenticationRepository>(context)
    //                 .user
    //                 .id,
    //             orderType: orderType,
    //             status: ' ',
    //           ),
    //           builder: (context, AsyncSnapshot<List<Order>> snapshot) {
    //             if (snapshot.hasData) {
    //               return ListView.builder(
    //                 itemCount: snapshot.data.length,
    //                 itemBuilder: (context, index) =>
    //                     _AdminOrderView(order: snapshot.data[index]),
    //               );
    //             } else if (snapshot.hasError) {
    //               return Text(snapshot.error.toString());
    //             } else {
    //               return const CircularProgressIndicator();
    //             }
    //           },
    //         );
    //       }
    //       return const Text('Something went wrong');
    //     },
    //   ),
    // );
  }
}

class _AdminOrderView extends StatelessWidget {
  const _AdminOrderView({Key key, this.order}) : super(key: key);

  final Order order;
  @override
  Widget build(BuildContext context) {
    // TODO: UI
    return ListTile(
      title: Text('Order #: ${order.id}'),
      subtitle: Text(
          'Address: ${order.address} \nPick Up: ${order.pickupDateAndTime}'),
      trailing: Container(
        child: IconButton(
          icon: const Icon(
            Icons.arrow_right,
            size: 30,
          ),
          onPressed: () {
            Navigator.pushNamed(
              context,
              OrderDetailPage.routeName,
              arguments: ScreenArguments(order: order),
            );
          },
        ),
      ),
    );
  }
}

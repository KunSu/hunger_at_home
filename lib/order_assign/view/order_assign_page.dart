import 'package:fe/components/models/screen_arguments.dart';
import 'package:fe/order_assign/order_assign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'body.dart';

class OrderAssignPage extends StatelessWidget {
  const OrderAssignPage({Key key}) : super(key: key);

  static String routeName = '/order_assign';

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    final order = args.order;

    return Scaffold(
      appBar: AppBar(title: const Text('Order assign')),
      body: RepositoryProvider(
        create: (context) => EmployeesRepository(),
        child: BlocProvider(
          create: (context) => OrderAssignBloc(
              employeesRepository:
                  RepositoryProvider.of<EmployeesRepository>(context)),
          child: Body(order: order),
        ),
      ),
    );
  }
}

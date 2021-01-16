import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/view/display_error.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_assign/order_assign.dart';
import 'package:fe/order_detail/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;

class Body extends StatefulWidget {
  const Body({
    Key key,
    @required this.order,
  }) : super(key: key);

  final Order order;

  @override
  _BodyState createState() => _BodyState(order);
}

class _BodyState extends State<Body> {
  _BodyState(this.order);

  Order order;
  OrderAssignBloc formBloc;

  @override
  Future<void> didChangeDependencies() async {
    final employeesRepository =
        RepositoryProvider.of<EmployeesRepository>(context);

    formBloc = RepositoryProvider.of<OrderAssignBloc>(context);
    formBloc.employees.clear();
    formBloc.orderID = order.id;
    formBloc.userID =
        RepositoryProvider.of<AuthenticationRepository>(context).user.id;

    var newEmployees = await employeesRepository.getAllEmployees();
    for (var user in newEmployees) {
      formBloc.employees.addItem(user.email);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return FormBlocListener<OrderAssignBloc, String, String>(
          onSuccess: (context, state) {
            var newOrder = order.copyWith(status: 'approved');
            context.read<OrdersBloc>().add(OrderUpdated(newOrder));
            Navigator.pop(context);
          },
          onFailure: (context, state) {
            displayError(
              context: context,
              error: state.failureResponse,
            );
          },
          child: Column(
            children: [
              orderDetailView(widget.order, context),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    DropdownFieldBlocBuilder(
                      selectFieldBloc: formBloc.employees,
                      itemBuilder: (context, value) => value,
                      decoration: const InputDecoration(
                          labelText: 'Employees', prefixIcon: Icon(Icons.edit)),
                    ),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: formBloc.submit,
                child: const Text('Assign'),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget orderDetailView(Order order, BuildContext context) {
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
                    title: const Text('Pick Up Date'),
                    subtitle: Text('${snapshot.data.pickupTime}'),
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  const BoxShadow(color: Colors.grey, spreadRadius: 1),
                ],
              ),
            ),
          ],
        );
      } else {
        return const CircularProgressIndicator();
      }
    },
  );
}

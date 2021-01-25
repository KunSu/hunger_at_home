import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/view/display_error.dart';
import 'package:fe/components/view/order/order_info.dart';
import 'package:fe/employee/employees_repository.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_assign/order_assign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

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
              OrderInfoView(order: order),
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

import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/address/addresses_repository.dart';
import 'package:fe/components/models/screen_arguments.dart';
import 'package:fe/components/view/display_error.dart';
import 'package:fe/components/view/my_circularprogress_indicator.dart';
import 'package:fe/item_edit/view/item_edit_page.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_edit/bloc/order_edit_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class OrderEditPage extends StatefulWidget {
  static String routeName = '/order_edit';

  @override
  _OrderEditPageState createState() => _OrderEditPageState();
}

class _OrderEditPageState extends State<OrderEditPage> {
  Order order;
  String screenTitle = 'Edit Order';
  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    order = args.order;
    if (args.screenTitle != null) {
      screenTitle = args.screenTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(screenTitle)),
      body: BlocProvider(
        create: (context) => OrderEditFormBloc(
          addressesRepository:
              RepositoryProvider.of<AddressesRepository>(context),
          authenticationRepository:
              RepositoryProvider.of<AuthenticationRepository>(context),
          ordersRepository: RepositoryProvider.of<OrdersRepository>(context),
          order: order,
        ),
        child: Builder(
          builder: (context) {
            final formBloc = RepositoryProvider.of<OrderEditFormBloc>(context);
            return FormBlocListener<OrderEditFormBloc, String, String>(
              onSuccess: (context, state) {
                Navigator.pop(context);
                BlocProvider.of<OrdersBloc>(context)
                    .add(OrderEdited(formBloc.order));
              },
              onFailure: (context, state) {
                displayError(
                  context: context,
                  error: state.failureResponse,
                );
              },
              child: BlocBuilder<OrderEditFormBloc, FormBlocState>(
                builder: (context, state) {
                  if (state is FormBlocLoaded) {
                    return EditOrderView(formBloc: formBloc);
                  } else {
                    if (state is FormBlocFailure) {
                      formBloc.emitLoaded();
                    }
                    return const MyCircularProgressIndicator();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class EditOrderView extends StatelessWidget {
  const EditOrderView({
    Key key,
    @required this.formBloc,
  }) : super(key: key);

  final OrderEditFormBloc formBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          RadioButtonGroupFieldBlocBuilder(
            selectFieldBloc: formBloc.pickupOrDropoff,
            itemBuilder: (context, value) => value,
            decoration: const InputDecoration(
              labelText: 'Do you want to pick up or drop off?',
              prefixIcon: SizedBox(),
            ),
          ),
          DateTimeFieldBlocBuilder(
            dateTimeFieldBloc: formBloc.pickupDateAndTime,
            canSelectTime: true,
            format: DateFormat('dd-MM-yyyy hh:mm'),
            initialDate: DateTime.now(),
            initialTime: TimeOfDay.fromDateTime(
                DateTime.now().add(const Duration(minutes: 30))),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            decoration: const InputDecoration(
              labelText: 'Pick Up Date and Time',
              prefixIcon: Icon(Icons.date_range),
            ),
          ),
          DropdownFieldBlocBuilder(
            selectFieldBloc: formBloc.addresses,
            itemBuilder: (context, value) => value,
            decoration: const InputDecoration(
                labelText: 'Addresses', prefixIcon: Icon(Icons.edit)),
          ),
          DropdownFieldBlocBuilder(
            selectFieldBloc: formBloc.dropoffAddress,
            itemBuilder: (context, value) => value,
            decoration: const InputDecoration(
                labelText: 'Drop off address', prefixIcon: Icon(Icons.edit)),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              child: OrderEditList(formBloc: formBloc),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 10),
              RaisedButton(
                onPressed: formBloc.submit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderEditList extends StatefulWidget {
  const OrderEditList({Key key, this.formBloc}) : super(key: key);
  final OrderEditFormBloc formBloc;

  @override
  _OrderEditListState createState() => _OrderEditListState();
}

class _OrderEditListState extends State<OrderEditList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.formBloc.order.items.length,
      itemBuilder: (context, index) {
        final item = widget.formBloc.order.items[index];

        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            setState(() {
              widget.formBloc.order.items.removeAt(index);
            });
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('${item.name} has been removed')));
          },
          background: Container(
            padding: const EdgeInsets.only(left: 5.0),
            color: Colors.red,
            child: const Center(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Swipe to remove this item',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          child: ListTile(
            title: Text('${item.name}'),
            subtitle: Text('${item.quantityNumber} ${item.quantityUnit}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemEditPage(
                      orderEditFormBloc: widget.formBloc,
                      item: item,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

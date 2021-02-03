import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/account/account.dart';
import 'package:fe/address/addresses_repository.dart';
import 'package:fe/admin_order/view/admin_order_page.dart';
import 'package:fe/anonymous_order/anonymous_order.dart';
import 'package:fe/components/models/screen_arguments.dart';
import 'package:fe/components/view/display_error.dart';
import 'package:fe/components/view/my_circularprogress_indicator.dart';
import 'package:fe/item/item_repository.dart';
import 'package:fe/item/view/view.dart';
import 'package:fe/order/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class AnonymousOrderPage extends StatelessWidget {
  static String routeName = '/order_edit';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anonymous Order')),
      body: BlocProvider(
        create: (context) => AnonymousOrderBloc(
          addressesRepository:
              RepositoryProvider.of<AddressesRepository>(context),
          authenticationRepository:
              RepositoryProvider.of<AuthenticationRepository>(context),
          ordersRepository: RepositoryProvider.of<OrdersRepository>(context),
          itemsRepository: RepositoryProvider.of<ItemsRepository>(context),
        ),
        child: Builder(
          builder: (context) {
            final formBloc = RepositoryProvider.of<AnonymousOrderBloc>(context);

            return FormBlocListener<AnonymousOrderBloc, String, String>(
              onSuccess: (context, state) {
                BlocProvider.of<OrdersBloc>(context)
                    .add(OrderAdded(formBloc.order));
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AdminOrderPage.routeName,
                  (route) => false,
                  arguments: ScreenArguments(
                    screenTitle: 'Donation orders',
                    orderType: <String>{'donation', 'dropoff', 'anonymous'},
                    status: <String>{'all'},
                  ),
                );
                formBloc.reset();
              },
              onFailure: (context, state) {
                displayError(
                  context: context,
                  error: state.failureResponse,
                );
              },
              child: BlocBuilder<AnonymousOrderBloc, FormBlocState>(
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

  final AnonymousOrderBloc formBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          DropdownFieldBlocBuilder(
            selectFieldBloc: formBloc.addresses,
            itemBuilder: (context, value) => value,
            decoration: const InputDecoration(
                labelText: 'Addresses', prefixIcon: Icon(Icons.edit)),
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
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AccountPage.routeName,
                    (route) => false,
                  );
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 10),
              RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    ItemPage.routeName,
                  );
                },
                child: const Text('Add more items'),
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
  final AnonymousOrderBloc formBloc;

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
                // Navigator.push(
                // context,
                // MaterialPageRoute(
                //   builder: (context) => ItemEditPage(
                //     item: item,
                //   ),
                // ),
                // );
              },
            ),
          ),
        );
      },
    );
  }
}

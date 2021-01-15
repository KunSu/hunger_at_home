import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/address/address.dart';
import 'package:fe/cart/bloc/cartform_bloc.dart';
import 'package:fe/cart/cart.dart';
import 'package:fe/components/view/display_error.dart';
import 'package:fe/item/item.dart';
import 'package:fe/order/bloc/orders_bloc.dart';
import 'package:fe/order/models/model.dart';
import 'package:fe/order/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  BodyState createState() => BodyState();
}

class BodyState extends State<Body> {
  CartFormBloc formBloc;
  @override
  Future<void> didChangeDependencies() async {
    formBloc = BlocProvider.of<CartFormBloc>(context);
    try {
      final authenticationRepository =
          RepositoryProvider.of<AuthenticationRepository>(context);
      final addressesRepository =
          RepositoryProvider.of<AddressesRepository>(context);

      var companyID = authenticationRepository.user.companyID;
      if (authenticationRepository.user.userIdentity == 'recipient') {
        companyID = '1'; // Hunger at Home default id
      }
      var newAddresses =
          await addressesRepository.loadAddressNames(companyID: companyID);

      formBloc.addresses.clear();
      for (var item in newAddresses) {
        formBloc.addresses.addItem(item);
      }
    } catch (e) {
      formBloc.emitFailure(failureResponse: e.toString());
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final identity = RepositoryProvider.of<AuthenticationRepository>(context)
        .user
        .userIdentity;
    return Builder(
      builder: (context) {
        return FormBlocListener<CartFormBloc, String, String>(
          onSuccess: (context, state) {
            if (formBloc.order == null) return;
            context.read<OrdersBloc>().add(OrderAdded(formBloc.order));

            // Reset status

            context.read<CartBloc>().add(CartStarted());
            context.read<CartFormBloc>().clear();
            context.read<CartFormBloc>().reset();
            Navigator.pushNamedAndRemoveUntil(
              context,
              OrderPage.routeName,
              (route) => false,
            );
          },
          onFailure: (context, state) {
            DisplayError(
              context: context,
              error: state.failureResponse,
            );
          },
          child: Padding(
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
                      labelText: 'Drop off address',
                      prefixIcon: Icon(Icons.edit)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: _CartList(),
                  ),
                ),
                const Divider(height: 4, color: Colors.black),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    if (state is CartLoaded) {
                      formBloc.items = state.cart.items;
                      return RaisedButton(
                        onPressed: formBloc.submit,
                        child: const Text('Submit Order'),
                      );
                    } else {
                      // TODO: better handling
                      return RaisedButton(
                        color: Colors.grey,
                        onPressed: () {},
                        child: const Text('Submit Order'),
                      );
                    }
                  },
                ),
                Visibility(
                  visible: identity == 'donor',
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AddressPage.routeName);
                    },
                    child: const Text('Add New Address'),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ItemPage.routeName);
                  },
                  child: Text(
                      "${identity == 'donor' ? 'Donate' : 'Request'} More Items"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return const CircularProgressIndicator();
        }
        if (state is CartLoaded) {
          return ListView.builder(
            itemCount: state.cart.items.length,
            itemBuilder: (context, index) =>
                _ItemView(item: state.cart.items[index]),
          );
        }
        return const Text('Something went wrong!');
      },
    );
  }
}

class _ItemView extends StatelessWidget {
  const _ItemView({Key key, this.item}) : super(key: key);

  final Item item;
  @override
  Widget build(BuildContext context) {
    // TODO: UI
    return ListTile(
      title: Text('${item.name}'),
      subtitle: Text(
          '${item.category} \n${item.quantityNumber} ${item.quantityUnit}'),
    );
  }
}

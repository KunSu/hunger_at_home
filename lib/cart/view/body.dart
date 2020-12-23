import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/address/address.dart';
import 'package:fe/authentication/authentication.dart';
import 'package:fe/cart/cart.dart';
import 'package:fe/donate/donate.dart';
import 'package:fe/order/bloc/orders_bloc.dart';
import 'package:fe/order/models/model.dart';
import 'package:fe/order/order.dart';
import 'package:fe/pantry/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class CartFormBloc extends FormBloc<String, String> {
  CartFormBloc(
      {@required this.authenticationRepository,
      @required this.addressesRepository}) {
    addFieldBlocs(
      fieldBlocs: [
        pickupDateAndTime,
        addresses,
      ],
    );
  }

  final AddressesRepository addressesRepository;
  final AuthenticationRepository authenticationRepository;

  final pickupDateAndTime = InputFieldBloc<DateTime, Object>(
    name: 'pickupDateAndTime',
    toJson: (value) => value.toUtc().toIso8601String(),
  );

  final addresses = SelectFieldBloc();

  @override
  void onSubmitting() async {
    emitSuccess();
  }

  @override
  Future<void> onLoading() async {
    addresses.clear();
    var newAddresses = await addressesRepository.loadAddressNames(
        companyID: authenticationRepository.getUser().companyID);
    for (var item in newAddresses) {
      addresses.addItem(item);
    }
    emitLoaded();
  }

  String getAddressID() {
    return addressesRepository.getAddressID(addresses.value);
  }
}

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final formBloc = BlocProvider.of<CartFormBloc>(context);
        formBloc.onLoading();
        return Column(
          children: [
            DateTimeFieldBlocBuilder(
              dateTimeFieldBloc: formBloc.pickupDateAndTime,
              canSelectTime: true,
              format: DateFormat('dd-mm-yyyy hh:mm'),
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              decoration: InputDecoration(
                labelText: 'Pick Up Date and Time',
                prefixIcon: Icon(Icons.date_range),
              ),
            ),
            DropdownFieldBlocBuilder(
              selectFieldBloc: formBloc.addresses,
              itemBuilder: (context, value) => value,
              decoration: InputDecoration(
                  labelText: 'Addresses',
                  prefixIcon: Icon(Icons.sentiment_satisfied)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: _CartList(),
              ),
            ),
            const Divider(height: 4, color: Colors.black),
            // _CartTotal()
            BlocBuilder<CartBloc, CartState>(builder: (context, state) {
              if (state is CartLoaded) {
                return RaisedButton(
                  onPressed: () {
                    var order = Order(
                      items: state.cart.items,
                      userID: context.read<AuthenticationBloc>().state.user.id,
                      address: formBloc.addresses.value,
                      pickupDateAndTime:
                          formBloc.pickupDateAndTime.value.toString(),
                    );
                    context.read<OrdersBloc>().add(OrderAdded(order));
                    Navigator.pushNamed(context, OrderPage.routeName);
                  },
                  child: Text('Submit order'),
                );
              }
            }),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, AddressPage.routeName);
              },
              child: const Text('Edit Address'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, DonatePage.routeName);
              },
              child: Text('Donate more items'),
            ),
            RaisedButton(
              onPressed: formBloc.onLoading,
              child: const Text('Reload'),
            ),
          ],
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
    return Column(children: [
      Text(item.name),
      Text(item.quantityNumber + ' ' + item.quantityUnit),
    ]);
  }
}

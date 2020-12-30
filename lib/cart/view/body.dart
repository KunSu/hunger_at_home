import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/address/address.dart';
import 'package:fe/cart/cart.dart';
import 'package:fe/item/item.dart';
import 'package:fe/order/bloc/orders_bloc.dart';
import 'package:fe/order/models/model.dart';
import 'package:fe/order/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class CartFormBloc extends FormBloc<String, String> {
  CartFormBloc({
    @required this.authenticationRepository,
    @required this.addressesRepository,
    @required this.ordersRepository,
  }) {
    addFieldBlocs(
      fieldBlocs: [
        pickupDateAndTime,
        addresses,
      ],
    );
  }

  final OrdersRepository ordersRepository;
  final AddressesRepository addressesRepository;
  final AuthenticationRepository authenticationRepository;

  final pickupDateAndTime = InputFieldBloc<DateTime, Object>(
    validators: [
      FieldBlocValidators.required,
    ],
    name: 'pickupDateAndTime',
    toJson: (value) => value.toUtc().toIso8601String(),
  );

  final addresses = SelectFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  List<Item> items;
  Order order;

  @override
  void onSubmitting() async {
    try {
      order = await ordersRepository.signUp(
        userID: authenticationRepository.user.id,
        addressID: addressesRepository.getAddressID(
          addresses.value,
        ),
        orderType: authenticationRepository.user.userIdentity == 'donor'
            ? 'donation'
            : 'request',
        pickUpTime: pickupDateAndTime.value.toString(),
        status: 'pending',
        orderItems: items,
      );
      emitSuccess(
        canSubmitAgain: true,
      );
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }
  }

  @override
  Future<void> onLoading() async {
    try {
      var companyID = authenticationRepository.user.companyID;
      print(authenticationRepository.user.userIdentity);
      if (authenticationRepository.user.userIdentity == 'recipient') {
        companyID = '0'; // Hunger At Home default id
      }
      var newAddresses =
          await addressesRepository.loadAddressNames(companyID: companyID);

      addresses.clear();
      for (var item in newAddresses) {
        addresses.addItem(item);
      }
      emitLoaded();
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }
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
    final identity = RepositoryProvider.of<AuthenticationRepository>(context)
        .user
        .userIdentity;
    return Builder(
      builder: (context) {
        final formBloc = BlocProvider.of<CartFormBloc>(context);
        formBloc.onLoading();
        return FormBlocListener<CartFormBloc, String, String>(
          onSuccess: (context, state) {
            context.read<OrdersBloc>().add(OrderAdded(formBloc.order));

            // Reset status
            context.read<CartBloc>().add(CartStarted());
            context.read<CartFormBloc>().pickupDateAndTime.clear();
            Navigator.pushNamedAndRemoveUntil(
              context,
              OrderPage.routeName,
              (route) => false,
            );
          },
          onFailure: (context, state) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failureResponse),
              ),
            );
          },
          child: Column(
            children: [
              DateTimeFieldBlocBuilder(
                dateTimeFieldBloc: formBloc.pickupDateAndTime,
                canSelectTime: true,
                format: DateFormat('dd-mm-yyyy hh:mm'),
                initialDate: DateTime.now(),
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

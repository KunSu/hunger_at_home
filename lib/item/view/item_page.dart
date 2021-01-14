import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/cart/cart.dart';
import 'package:fe/components/view/buttom_navigation_bar.dart';
import 'package:fe/item/bloc/item_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class ItemPage extends StatelessWidget {
  static String routeName = '/item';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<ItemBloc>(context);

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Item'),
                // floating: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () => Navigator.of(context).pushNamed('/cart'),
                  ),
                ],
              ),
              body: FormBlocListener<ItemBloc, String, String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);
                  context.read<CartBloc>().add(CartItemAdded(formBloc.item));
                  Navigator.of(context).pushNamed('/cart');
                },
                onFailure: (context, state) {
                  LoadingDialog.hide(context);

                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text(state.failureResponse)));
                },
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.name,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Item Name',
                            prefixIcon: Icon(Icons.assignment),
                          ),
                        ),
                        DropdownFieldBlocBuilder(
                          selectFieldBloc: formBloc.category,
                          itemBuilder: (context, value) => value,
                          decoration: const InputDecoration(
                              labelText: 'category',
                              prefixIcon: Icon(Icons.category)),
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.quantityNumber,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Quantity',
                            prefixIcon: Icon(Icons.edit),
                          ),
                        ),
                        DropdownFieldBlocBuilder(
                          selectFieldBloc: formBloc.quantityUnit,
                          itemBuilder: (context, value) => value,
                          decoration: const InputDecoration(
                              labelText: 'Quantity Unit',
                              prefixIcon: Icon(Icons.edit)),
                        ),
                        RaisedButton(
                          onPressed: formBloc.submit,
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: MyBottomNavigationBar(
                identity:
                    RepositoryProvider.of<AuthenticationRepository>(context)
                        .user
                        .userIdentity,
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  LoadingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

import 'package:fe/item_edit/bloc/item_edit_bloc.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_edit/bloc/order_edit_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class ItemEditPage extends StatelessWidget {
  ItemEditPage({Key key, this.orderEditFormBloc, this.item}) : super(key: key);

  static String routeName = '/item_edit';
  final OrderEditFormBloc orderEditFormBloc;
  final Item item;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ItemEditBloc(item: item, orderEditFormBloc: orderEditFormBloc),
      child: Builder(
        builder: (context) {
          final formBloc = RepositoryProvider.of<ItemEditBloc>(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Item'),
            ),
            body: FormBlocListener<ItemEditBloc, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSuccess: (context, state) {
                LoadingDialog.hide(context);
                Navigator.pop(context);
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);

                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text(state.failureResponse)));
              },
              child: SingleChildScrollView(
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

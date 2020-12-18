import 'package:fe/cart/cart.dart';
import 'package:fe/pantry/models/models.dart';
import 'package:fe/pantry/view/pantry_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class DonatePageBloc extends FormBloc<String, String> {
  DonatePageBloc() {
    addFieldBlocs(
      fieldBlocs: [
        name,
        category,
        // pickupDateAndTime,
        quantityNumber,
        quantityUnit,
        // address
      ],
    );
  }

  final name = TextFieldBloc();

  final category = SelectFieldBloc(
    items: [
      'Fruits',
      'Veggies',
      'Meat',
      'Seafood',
      'Dry',
    ],
  );

  final quantityNumber = TextFieldBloc();
  final quantityUnit = SelectFieldBloc(
    items: [
      'pallet',
      'case',
      'pound',
    ],
  );

  // final pickupDateAndTime = InputFieldBloc<DateTime, Object>(
  //   name: 'pickupDateAndTime',
  //   toJson: (value) => value.toUtc().toIso8601String(),
  // );

  // final address = SelectFieldBloc(
  //   items: [
  //     'address 1',
  //     'address 2',
  //   ],
  // );

  @override
  void onSubmitting() async {
    emitSuccess();
  }
}

class DonatePage extends StatelessWidget {
  static String routeName = '/donate';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DonatePageBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<DonatePageBloc>(context);

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
                title: const Text('Donate'),
                // floating: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () => Navigator.of(context).pushNamed('/cart'),
                  ),
                ],
              ),
              body: FormBlocListener<DonatePageBloc, String, String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);
                  final item = Item(
                    id: '1',
                    name: formBloc.name.value,
                    category: formBloc.category.value,
                    // pickupDateAndTime:
                    //     formBloc.pickupDateAndTime.value.toString(),
                    quantityNumber: formBloc.quantityNumber.value,
                    quantityUnit: formBloc.quantityUnit.value,
                    // address: formBloc.address.value,
                  );
                  context.read<CartBloc>().add(CartItemAdded(item));
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
                          decoration: InputDecoration(
                            labelText: 'Item Name',
                            prefixIcon: Icon(Icons.sentiment_very_satisfied),
                          ),
                        ),
                        // TODO: the DropdownField has bug
                        DropdownFieldBlocBuilder(
                          selectFieldBloc: formBloc.category,
                          itemBuilder: (context, value) => value,
                          decoration: InputDecoration(
                              labelText: 'category',
                              prefixIcon: Icon(Icons.sentiment_satisfied)),
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.quantityNumber,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                            prefixIcon: Icon(Icons.sentiment_very_satisfied),
                          ),
                        ),
                        DropdownFieldBlocBuilder(
                          selectFieldBloc: formBloc.quantityUnit,
                          itemBuilder: (context, value) => value,
                          decoration: InputDecoration(
                              labelText: 'Quantity Unit',
                              prefixIcon: Icon(Icons.sentiment_satisfied)),
                        ),
                        // DateTimeFieldBlocBuilder(
                        //   dateTimeFieldBloc: formBloc.pickupDateAndTime,
                        //   canSelectTime: true,
                        //   format: DateFormat('dd-mm-yyyy hh:mm'),
                        //   initialDate: DateTime.now(),
                        //   firstDate: DateTime(1900),
                        //   lastDate: DateTime(2100),
                        //   decoration: InputDecoration(
                        //     labelText: 'Pick Up Date and Time',
                        //     prefixIcon: Icon(Icons.date_range),
                        //   ),
                        // ),
                        // DropdownFieldBlocBuilder(
                        //   selectFieldBloc: formBloc.address,
                        //   itemBuilder: (context, value) => value,
                        //   decoration: InputDecoration(
                        //       labelText: 'Addresses',
                        //       prefixIcon: Icon(Icons.sentiment_satisfied)),
                        // ),
                        RaisedButton(
                          onPressed: formBloc.submit,
                          child: Text('Submit'),
                        ),
                      ],
                    ),
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

import 'package:fe/components/models/screen_arguments.dart';
import 'package:fe/item/bloc/item_bloc.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_detail/order_detail_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class OrderEditPage extends StatefulWidget {
  static String routeName = '/order_edit';

  @override
  _OrderEditPageState createState() => _OrderEditPageState();
}

class _OrderEditPageState extends State<OrderEditPage> {
  Order order;
  @override
  void didChangeDependencies() {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    order = args.order;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Order')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              child: ItemEditList(order: order),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  const BoxShadow(color: Colors.grey, spreadRadius: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemEditList extends StatelessWidget {
  const ItemEditList({Key key, this.order}) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Item>>(
        future: OrderDetailRepository().loadOrderItems(
          // userID:
          //     RepositoryProvider.of<AuthenticationRepository>(context).user.id,
          orderID: order.id,
        ),
        builder: (context, AsyncSnapshot<List<Item>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) =>
                  ItemEditView(item: snapshot.data[index]),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

class ItemEditView extends StatefulWidget {
  const ItemEditView({Key key, this.item}) : super(key: key);

  final Item item;

  @override
  _ItemEditViewState createState() => _ItemEditViewState();
}

class _ItemEditViewState extends State<ItemEditView> {
  var formBloc;
  @override
  void didChangeDependencies() {
    formBloc = ItemBloc();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            title: Text('${widget.item.name}'),
            subtitle: Text('Description'),
          ),
          DropdownFieldBlocBuilder(
            selectFieldBloc: formBloc.category,
            itemBuilder: (context, value) => value,
            decoration: const InputDecoration(
                labelText: 'category', prefixIcon: Icon(Icons.category)),
          ),
        ],
      ),
    );
  }
}

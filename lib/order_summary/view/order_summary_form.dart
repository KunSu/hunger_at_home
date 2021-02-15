import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/view/display_error.dart';
import 'package:fe/components/view/my_circularprogress_indicator.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_summary/order_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class OrderSummaryForm extends StatelessWidget {
  const OrderSummaryForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider(
        create: (context) => OrderSummaryBloc(
          authenticationRepository:
              RepositoryProvider.of<AuthenticationRepository>(context),
          ordersRepository: RepositoryProvider.of<OrdersRepository>(context),
        ),
        child: Builder(
          builder: (context) {
            final formBloc = RepositoryProvider.of<OrderSummaryBloc>(context);
            return FormBlocListener<OrderSummaryBloc, String, String>(
              onSuccess: (context, state) {
                if (!formBloc.download) {
                  try {
                    context.read<OrdersBloc>().add(OrderLoadSummary(
                          userID:
                              RepositoryProvider.of<AuthenticationRepository>(
                                      context)
                                  .user
                                  .id,
                          startDate: formBloc.startDate.value.toIso8601String(),
                          endDate: formBloc.endDate.value.toIso8601String(),
                          type: <String>{'all'},
                          status: <String>{'all'},
                          download: formBloc.download,
                        ));
                    formBloc.emitLoaded();
                  } catch (e) {
                    formBloc.emitFailure(failureResponse: e.toString());
                  }
                }
              },
              onFailure: (context, state) {
                displayError(
                  context: context,
                  error: state.failureResponse,
                );
              },
              child: BlocBuilder<OrderSummaryBloc, FormBlocState>(
                builder: (context, state) {
                  if (state is FormBlocLoaded) {
                    return OrderSummaryFormView(
                      formBloc: formBloc,
                    );
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

class OrderSummaryFormView extends StatelessWidget {
  OrderSummaryFormView({
    Key key,
    @required this.formBloc,
  }) : super(key: key);

  final OrderSummaryBloc formBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          DateTimeFieldBlocBuilder(
            dateTimeFieldBloc: formBloc.startDate,
            format: DateFormat('dd-MM-yyyy'),
            initialDate: DateTime.now().subtract(const Duration(days: 7)),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            decoration: const InputDecoration(
              labelText: 'Start date',
              prefixIcon: Icon(Icons.date_range),
            ),
          ),
          DateTimeFieldBlocBuilder(
            dateTimeFieldBloc: formBloc.endDate,
            format: DateFormat('dd-MM-yyyy'),
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            decoration: const InputDecoration(
              labelText: 'End date',
              prefixIcon: Icon(Icons.date_range),
            ),
          ),
          // DropdownFieldBlocBuilder(
          //   selectFieldBloc: formBloc.type,
          //   itemBuilder: (context, value) => value,
          //   decoration: const InputDecoration(
          //       labelText: 'Order type', prefixIcon: Icon(Icons.edit)),
          // ),
          // DropdownFieldBlocBuilder(
          //   selectFieldBloc: formBloc.status,
          //   itemBuilder: (context, value) => value,
          //   decoration: const InputDecoration(
          //       labelText: 'Order status', prefixIcon: Icon(Icons.edit)),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: formBloc.submit,
                child: const Text('Load summary'),
              ),
              const SizedBox(width: 10),
              RaisedButton(
                onPressed: () {
                  Scaffold.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'This function will be released in the next version.'),
                    ),
                  );
                },
                // () {
                //   formBloc.setDownload(true);
                //   formBloc.submit();
                // },
                child: const Text('Download'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

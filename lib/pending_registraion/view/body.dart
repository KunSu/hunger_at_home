import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/view/my_circularprogress_indicator.dart';
import 'package:fe/pending_registraion/pending_registraion.dart';
import 'package:fe/pending_registraion/view/pending_registraion_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<EmployeesBloc>(context).add(EmployeesLoaded());
    RepositoryProvider.of<AuthenticationRepository>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return BlocListener<EmployeesBloc, EmployeesState>(
          listener: (context, state) {
            if (state is EmployeesFailure) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            }
          },
          child: BlocBuilder<EmployeesBloc, EmployeesState>(
            builder: (context, state) {
              if (state is EmployeesInitial) {
                return const MyCircularProgressIndicator();
              } else if (state is EmployeesSuccess) {
                if (state.users == null || state.users.isEmpty) {
                  return const Text(
                      'You do not have any pending registration yet');
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    BlocProvider.of<EmployeesBloc>(context)
                        .add(EmployeesLoaded());
                  },
                  child: ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) =>
                        PendingRegistrationView(user: state.users[index]),
                  ),
                );
              } else if (state is EmployeesFailure) {
                BlocProvider.of<EmployeesBloc>(context).add(EmployeesLoaded());
                return const MyCircularProgressIndicator();
              } else {
                return Container(
                  child: const Center(
                    child: Text('Something went wrong'),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}

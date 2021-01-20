import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/components/ult/status_color.dart';
import 'package:fe/components/view/dialog/user_update_dialog.dart';
import 'package:fe/pending_registraion/pending_registraion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;

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
                return const CircularProgressIndicator();
              }
              if (state is EmployeesSuccess) {
                if (state.users == null || state.users.isEmpty) {
                  return const Text(
                      'You do not have any pending registration yet');
                }
                return ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) =>
                      _PendingRegistrationView(user: state.users[index]),
                );
              }
              if (state is EmployeesFailure) {
                BlocProvider.of<EmployeesBloc>(context).add(EmployeesLoaded());
                return const CircularProgressIndicator();
              }
              return const Text('Something went wrong');
            },
          ),
        );
      },
    );
  }
}

class _PendingRegistrationView extends StatelessWidget {
  _PendingRegistrationView({Key key, this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              subtitle: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Email: ${user.email}\n',
                          ),
                          const TextSpan(
                            text: 'First name: ',
                          ),
                          TextSpan(
                            text: '${user.firstName}\n',
                          ),
                          const TextSpan(
                            text: 'Last name: ',
                          ),
                          TextSpan(
                            text: '${user.lastName}\n',
                          ),
                          const TextSpan(
                            text: 'Status: ',
                          ),
                          TextSpan(
                            text: '${user.status}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: getStatusColor(status: user.status),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.phone,
                      size: 30,
                    ),
                    subtitle: FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () =>
                          url_launcher.launch('tel:+${user.phoneNumber}'),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${user.phoneNumber}',
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: user.status == 'pending',
                  child: TextButton(
                    child: const Text('Approved'),
                    onPressed: () {
                      userUpdateDialog(
                        context: context,
                        status: 'approved',
                        userID: RepositoryProvider.of<AuthenticationRepository>(
                                context)
                            .user
                            .id,
                        email: user.email,
                        title: 'Confirmation',
                        text:
                            'Please confirm if you want to approve this user.',
                      );
                    },
                  ),
                ),
                Visibility(
                  visible: user.status == 'pending',
                  child: TextButton(
                    child: const Text('Withdraw'),
                    onPressed: () {
                      userUpdateDialog(
                        context: context,
                        status: 'withdraw',
                        userID: user.id,
                        email: user.email,
                        title: 'Confirmation',
                        text:
                            'Please confirm if you want to withdraw this user.',
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

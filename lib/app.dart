import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/donor/donor.dart';
import 'package:fe/employee/employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fe/authentication/authentication.dart';
import 'package:fe/home/home.dart';
import 'package:fe/login/login.dart';

import 'constants.dart';

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.authenticationRepository,
  })  : assert(authenticationRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
        ),
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hunger At Home',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                if ('1' == state.user.id) {
                  _navigator.pushAndRemoveUntil<void>(
                    HomePage.route(),
                    (route) => false,
                  );
                } else if ('2' == state.user.id) {
                  _navigator.pushAndRemoveUntil<void>(
                    DonorPage.route(),
                    (route) => false,
                  );
                } else if ('3' == state.user.id) {
                  _navigator.pushAndRemoveUntil<void>(
                    EmployeePage.route(),
                    (route) => false,
                  );
                }
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },

      // TODO: confirm routing style
      routes: {
        '/': (context) => BlocProvider.value(
              value: LoginBloc(
                authenticationRepository:
                    RepositoryProvider.of<AuthenticationRepository>(context),
              ),
              child: LoginPage(),
            ),
        // '/home': (context) => BlocProvider.value(
        //       value: BlocProvider.of<AuthenticationBloc>(context),
        //       child: HomePage(),
        //     ),
        // '/donor': (context) => BlocProvider.value(
        //       value: BlocProvider.of<AuthenticationBloc>(context),
        //       child: DonorPage(),
        //     ),
        // '/employee': (context) => BlocProvider.value(
        //   value: BlocProvider.of<AuthenticationBloc>(context),
        //   child: EmployeePage(),
        // ),
      },
    );
  }
}

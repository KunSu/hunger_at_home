import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/approver/view/approver_page.dart';
import 'package:fe/cart/bloc/cart_bloc.dart';
import 'package:fe/order/bloc/orders_bloc.dart';
import 'package:fe/order/order_repository.dart';
import 'package:fe/pantry/bloc/catalog_bloc.dart';
import 'package:fe/components/constants.dart';
import 'package:fe/donor/donor.dart';
import 'package:fe/employee/employee.dart';
import 'package:fe/recipient/view/recipient_page.dart';
import 'package:fe/register/bloc/register_bloc.dart';
import 'package:fe/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fe/authentication/authentication.dart';
import 'package:fe/login/login.dart';

import 'routes.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<CatalogBloc>(
          create: (_) => CatalogBloc()..add(CatalogStarted()),
        ),
        BlocProvider<CartBloc>(
          create: (_) => CartBloc()..add(CartStarted()),
        ),
        BlocProvider<OrdersBloc>(
          create: (_) => OrdersBloc(ordersRepository: OrdersRepository())
            ..add(OrdersLoaded()),
        ),
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(
            authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context),
          ),
        ),
        BlocProvider<RegisterBloc>(
          create: (_) => RegisterBloc(
            authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context),
          ),
        ),
      ],
      child: MaterialApp(
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
                  if ('recipient' == state.user.useridentity) {
                    _navigator.pushAndRemoveUntil<void>(
                      RecipientPage.route(),
                      (route) => false,
                    );
                  } else if ('donor' == state.user.useridentity) {
                    _navigator.pushAndRemoveUntil<void>(
                      DonorPage.route(),
                      (route) => false,
                    );
                  } else if ('employee' == state.user.useridentity) {
                    _navigator.pushAndRemoveUntil<void>(
                      EmployeePage.route(),
                      (route) => false,
                    );
                  } else if ('approver' == state.user.useridentity) {
                    _navigator.pushAndRemoveUntil<void>(
                      ApproverPage.route(),
                      (route) => false,
                    );
                  }

                  break;
                case AuthenticationStatus.unauthenticated:
                  _navigator.pushAndRemoveUntil<void>(
                    WelcomePage.route(),
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

        initialRoute: '/',
        // TODO: confirm routing style
        routes: routes,
        // {
        //   '/': (context) => WelcomePage(),
        //   '/login': (context) => LoginPage(),
        //   '/register': (context) => RegisterPage(),
        //   '/': (context) => BlocProvider.value(
        //         value: LoginBloc(
        //           authenticationRepository:
        //               RepositoryProvider.of<AuthenticationRepository>(context),
        //         ),
        //         child: WelcomePage(),
        //       ),
        //   '/login': (context) => BlocProvider.value(
        //         value: LoginBloc(
        //           authenticationRepository:
        //               RepositoryProvider.of<AuthenticationRepository>(context),
        //         ),
        //         child: LoginPage(),
        //       ),
        //   '/register': (context) => BlocProvider.value(
        //         value: RegisterBloc(
        //           authenticationRepository:
        //               RepositoryProvider.of<AuthenticationRepository>(context),
        //         ),
        //         child: RegisterPage(),
        //   ),
        //   '/employee': (context) => BlocProvider.value(
        //     value: BlocProvider.of<AuthenticationBloc>(context),
        //     child: EmployeePage(),
        //   ),
        // },
      ),
    );
  }
}

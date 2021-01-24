import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/address/address.dart';
import 'package:fe/admin/view/admin_page.dart';
import 'package:fe/cart/bloc/cartform_bloc.dart';
import 'package:fe/cart/cart.dart';
import 'package:fe/company/company.dart';
import 'package:fe/pending_registraion/pending_registraion.dart';
import 'package:fe/order/order.dart';
import 'package:fe/pantry/bloc/catalog_bloc.dart';
import 'package:fe/components/constants.dart';
import 'package:fe/donor/donor.dart';
import 'package:fe/employee/employee.dart';
import 'package:fe/recipient/view/recipient_page.dart';
import 'package:fe/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fe/authentication/authentication.dart';

import 'home/view/home_page.dart';
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
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AddressesRepository>(
              create: (context) => AddressesRepository(),
            ),
            RepositoryProvider<OrdersRepository>(
              create: (context) => OrdersRepository(),
            ),
            RepositoryProvider<EmployeesRepository>(
              create: (context) => EmployeesRepository(),
            ),
          ],
          child: AppView(),
        ),
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
    // TODO： refactor all Bloc
    return MultiBlocProvider(
      providers: [
        BlocProvider<CatalogBloc>(
          create: (_) => CatalogBloc()..add(CatalogStarted()),
        ),
        BlocProvider<CartBloc>(
          create: (_) => CartBloc()..add(CartStarted()),
        ),
        BlocProvider<OrdersBloc>(
          create: (_) => OrdersBloc(
            ordersRepository: RepositoryProvider.of<OrdersRepository>(context),
            addressesRepository:
                RepositoryProvider.of<AddressesRepository>(context),
            authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context),
          )..add(OrdersLoaded()),
        ),
        BlocProvider<CompanyBloc>(
          create: (_) => CompanyBloc(
            companiesRepository: CompaniesRepository(),
          ),
        ),
        BlocProvider<CartFormBloc>(
          create: (_) => CartFormBloc(
              addressesRepository:
                  RepositoryProvider.of<AddressesRepository>(context),
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context),
              ordersRepository:
                  RepositoryProvider.of<OrdersRepository>(context)),
        ),
        BlocProvider<EmployeesBloc>(
          create: (_) => EmployeesBloc(
              employeesRepository:
                  RepositoryProvider.of<EmployeesRepository>(context))
            ..add(EmployeesLoaded()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hunger at Home',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        navigatorKey: _navigatorKey,
        builder: (context, child) {
          return BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              switch (state.status) {
                case AuthenticationStatus.authenticated:
                  if (state.user.status != 'approved') {
                    _navigator.pushAndRemoveUntil<void>(
                      HomePage.route(),
                      (route) => false,
                    );
                    break;
                  }
                  if ('recipient' == state.user.userIdentity) {
                    _navigator.pushAndRemoveUntil<void>(
                      RecipientPage.route(),
                      (route) => false,
                    );
                  } else if ('donor' == state.user.userIdentity) {
                    _navigator.pushAndRemoveUntil<void>(
                      DonorPage.route(),
                      (route) => false,
                    );
                  } else if ('employee' == state.user.userIdentity) {
                    _navigator.pushAndRemoveUntil<void>(
                      EmployeePage.route(),
                      (route) => false,
                    );
                  } else if ('admin' == state.user.userIdentity) {
                    _navigator.pushAndRemoveUntil<void>(
                      AdminPage.route(),
                      (route) => false,
                    );
                  }

                  break;
                case AuthenticationStatus.unauthenticated:
                  _navigator.pushAndRemoveUntil<void>(
                    WelcomePage.route(),
                    (route) => false,
                  );

                  // TODO: better handle
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  exit(0);
                  break;
                default:
                  break;
              }
            },
            child: child,
          );
        },
        initialRoute: '/',
        routes: routes,
      ),
    );
  }
}

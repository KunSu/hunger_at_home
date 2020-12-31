import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/address/address.dart';
import 'package:fe/admin/view/admin_page.dart';
import 'package:fe/cart/cart.dart';
import 'package:fe/cart/view/body.dart';
import 'package:fe/company/company.dart';
import 'package:fe/order/bloc/orders_bloc.dart';
import 'package:fe/order/order_repository.dart';
import 'package:fe/pantry/bloc/catalog_bloc.dart';
import 'package:fe/components/constants.dart';
import 'package:fe/donor/donor.dart';
import 'package:fe/employee/employee.dart';
import 'package:fe/recipient/view/recipient_page.dart';
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
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AddressesRepository>(
              create: (context) => AddressesRepository(),
            ),
            RepositoryProvider<OrdersRepository>(
              create: (context) => OrdersRepository(),
            ),
            // RepositoryProvider<RepositoryC>(
            //   create: (context) => RepositoryC(),
            // ),
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
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(
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
                  } else if ('approver' == state.user.userIdentity) {
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

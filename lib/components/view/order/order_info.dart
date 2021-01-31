import 'package:authentication_repository/authentication_repository.dart';
import 'package:fe/order/order.dart';
import 'package:fe/order_detail/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class OrderInfoView extends StatefulWidget {
  const OrderInfoView({Key key, this.order}) : super(key: key);
  final Order order;

  @override
  _OrderInfoViewState createState() => _OrderInfoViewState();
}

class _OrderInfoViewState extends State<OrderInfoView> {
  openMapsSheet({BuildContext context, String address}) async {
    try {
      print('address: $address');
      var locations = await locationFromAddress(address);

      final first = locations.first;
      final coords = Coords(first.latitude, first.longitude);
      final availableMaps = await MapLauncher.installedMaps;

      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: address,
                        ),
                        title: Text(map.mapName),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OrderDetail>(
      future: OrderDetailRepository().loadOrderDetail(
        userID:
            RepositoryProvider.of<AuthenticationRepository>(context).user.id,
        orderID: widget.order.id,
      ),
      builder: (context, AsyncSnapshot<OrderDetail> snapshot) {
        if (snapshot.hasData) {
          final address =
              '${snapshot.data.address}, ${snapshot.data.city}, ${snapshot.data.state} ${snapshot.data.zipCode}';
          return Column(
            children: [
              Container(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Company'),
                      subtitle: Text('${snapshot.data.companyName}'),
                    ),
                    ListTile(
                      title: const Text('Order Type'),
                      subtitle: Text('${snapshot.data.orderType}'),
                    ),
                    Visibility(
                      visible: snapshot.data.orderType != 'dropoff',
                      child: ListTile(
                        title: const Text('Pick Up Date'),
                        subtitle: Text('${snapshot.data.pickupTime}'),
                      ),
                    ),
                    Visibility(
                      visible: snapshot.data.orderType == 'dropoff',
                      child: const ListTile(
                        title: Text('Drop off order'),
                      ),
                    ),
                    ListTile(
                      title: const Text('Contact Number'),
                      subtitle: FlatButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => url_launcher
                            .launch('tel:+${snapshot.data.phoneNumber}'),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${snapshot.data.phoneNumber}',
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text('Address: '),
                      subtitle: FlatButton(
                        padding: EdgeInsets.zero,
                        onPressed: () =>
                            openMapsSheet(context: context, address: address),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('$address'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

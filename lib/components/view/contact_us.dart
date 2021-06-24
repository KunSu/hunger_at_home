import 'package:fe/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

Future<void> contactUs({
  @required BuildContext context,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Contact Information'),
        content: const SingleChildScrollView(
          child: ContactUsView(),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Back'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class ContactUsView extends StatefulWidget {
  const ContactUsView({Key key}) : super(key: key);

  @override
  _ContactUsViewState createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
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
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              const ListTile(
                title: Text('Company'),
                subtitle: Text('Hunger at Home'),
              ),
              ListTile(
                title: const Text('Contact Number'),
                subtitle: FlatButton(
                  padding: EdgeInsets.zero,
                  onPressed: () =>
                      url_launcher.launch('tel:+$hungerAtHomePhoneNumber'),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '$hungerAtHomePhoneNumber',
                    ),
                  ),
                ),
              ),
              ListTile(
                title: const Text('Address: '),
                subtitle: FlatButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => openMapsSheet(
                      context: context, address: hungerAtHomeAddress),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('$hungerAtHomeAddress'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

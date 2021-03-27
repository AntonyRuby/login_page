import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:location_platform_interface/location_platform_interface.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LocationData locationData;
  bool _serviceEnabled;
  PermissionStatus _permission;
  List<Address> address;

  Future getPosition() async {
    Location location = new Location();

    _serviceEnabled = await location.serviceEnabled();
    if (_serviceEnabled) {
      print("Service is enabled.");

      _permission = await location.hasPermission();
      if (_permission == PermissionStatus.denied) {
        _permission = await location.requestPermission();
        if (_permission != PermissionStatus.granted) {
          return {'message': "Permissions denied"};
        }
      }

      locationData = await location.getLocation();
      print("${locationData.latitude}, ${locationData.longitude}");

      address = await Geocoder.local.findAddressesFromCoordinates(
          Coordinates(locationData.latitude, locationData.longitude));

      return {'address': address};
    } else {
      print("Service not enabled.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPosition(),
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Current Location"),
                centerTitle: true,
              ),
              body: () {
                if (snapshot.hasData) {
                  return _permission != PermissionStatus.granted
                      ? LocationUnavailable(
                          message: snapshot.data['message'],
                        )
                      : CurrentLocation(
                          location: locationData,
                          address:
                              "${snapshot.data['address'][0].subLocality}, ${snapshot.data['address'][0].locality}"
                          // address: addressData,
                          );
                } else {
                  return Stack(children: [
                    Center(
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.blue,
                        size: 56,
                      ),
                    ),
                    Center(
                        child: SizedBox(
                      height: MediaQuery.of(context).size.width * 0.3,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: CircularProgressIndicator(
                        strokeWidth: 6,
                      ),
                    ))
                  ]);
                }
              }());
        });
  }
}

class CurrentLocation extends StatelessWidget {
  final LocationData location;
  final String address;

  CurrentLocation({@required this.location, @required this.address});

  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat("#.###");

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          child: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          RichText(
            text: TextSpan(
                text: "Latitude: ",
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: formatter.format(location.latitude),
                      style: TextStyle(color: Colors.green))
                ]),
          ),
          RichText(
            text: TextSpan(
                text: "Longitude: ",
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: formatter.format(location.longitude),
                      style: TextStyle(color: Colors.green))
                ]),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Location: ",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              RichText(
                maxLines: 3,
                text: TextSpan(
                  text: address,
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
        ],
      ))),
    );
  }
}

class LocationUnavailable extends StatelessWidget {
  final String message;

  LocationUnavailable({@required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_off,
          size: 54,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        Text("Location permissions required",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      ],
    )));
  }
}

import 'dart:async';
import 'package:campus_connect/screens/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class DisplayMap extends StatefulWidget {
  const DisplayMap({Key? key, required this.driverID, required this.source})
      : super(key: key);

  final int driverID;
  final LatLng source;

  @override
  State<DisplayMap> createState() => DisplayMapState();
}

class DisplayMapState extends State<DisplayMap> {
  final Completer<GoogleMapController> _controller = Completer();

  final databaseReference = FirebaseDatabase.instance.ref();

  static LatLng destination = const LatLng(0, 0);
  static const LatLng sourceLocation = LatLng(10.18325, 76.42885);
  static LatLng driverLoc = const LatLng(0, 0);
  // static const LatLng destination = LatLng(10.02221, 76.30113);

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  Future<void> _getDriverLocation() async {
    // int driverid1 = int.parse(widget.driverID);
    print(
        "10920809338478622222222255444444444444444444444444444444444444444444444${widget.driverID.runtimeType}");
    final query = databaseReference.child('locations');
    // .orderByChild('driverId').equalTo(1);

    GoogleMapController googleMapController = await _controller.future;

    // setState(() {
    query.once().then((event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> driverData =
          snapshot.value as Map<dynamic, dynamic>;
      driverData.forEach((driverId, driverInfo) {
        print(
            "11111111111111111111111111111122222222222222222222222222222222222 $driverId");
        print(
            "11111111111111111111111111111122222222222222222222222222222222222 $driverInfo");
        // if (driverId == driverIdToFind) { 
        //   // do something with driverInfo
        //   print(driverInfo["latitude"]);
        //   print(driverInfo["longitude"]);
        // }
      });
      print('1234576793798436038462Data : ${driverData["driver1"]}');
      driverLoc = LatLng(driverData["driver1"]["latitude"],
          driverData["driver1"]["longitude"]);
    });
    // });

    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 14.5,
          target: driverLoc,
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    setState(() {
      currentLocation = locationData;
    });

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLoc) {
      setState(() {
        currentLocation = newLoc;
      });
      print("New Location: $currentLocation");

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 14.5,
            target: LatLng(newLoc.latitude!, newLoc.longitude!),
          ),
        ),
      );
    });
  }

  /*initializeGeoFireListener() {
    Geofire.initialize("activeDrivers");
  } */

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    print(result.points);
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }

      setState(() {});
    } else {
      print(
          "11111111111111111111111111111111111111111111111111 ${result.errorMessage}");
    }
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/pin_source.png")
        .then(
      (icon) {
        sourceIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/pin_destination.png")
        .then(
      (icon) {
        destinationIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/bus-stop-icon.png")
        .then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
  }

  @override
  void initState() {
    destination = widget.source;
    _getCurrentLocation();
    _getDriverLocation();
    setCustomMarkerIcon();
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(currentLocation);
    print(widget.source);
    _getDriverLocation();
    print(widget.driverID);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Campus Connect",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: driverLoc,
                zoom: 14.5,
              ),
              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: polylineCoordinates,
                  // color: primaryColor,
                  // width: 6,
                ),
              },
              markers: {
                Marker(
                  markerId: const MarkerId("currentLocation"),
                  icon: currentLocationIcon,
                  position: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                ),
                Marker(
                    markerId: const MarkerId("source"),
                    icon: sourceIcon,
                    position: sourceLocation),
                Marker(
                  markerId: const MarkerId("destination"),
                  icon: destinationIcon,
                  position: destination,
                ),
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              }),
    );
  }
}

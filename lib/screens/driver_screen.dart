// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:location/location.dart';

// class DriverPage extends StatefulWidget {
//   const DriverPage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _DriverPageState createState() => _DriverPageState();
// }

// class _DriverPageState extends State<DriverPage> {
//   String driverid = 'driver1'; // Change this to the driver's ID
//   //DatabaseReference? _driverLocationRef = null;

//   late DatabaseReference _driverLocationRef;
//   double _latitude = 0.0;
//   double _longitude = 0.0;

//   @override
//   void initState() {
//     super.initState();

//     // Obtain a reference to the driver's location data in the Firebase Realtime Database
//     _driverLocationRef =
//         FirebaseDatabase.instance.ref().child('locations').child(driverid);
//     Timer.periodic(Duration(seconds: 3), (Timer t) => _updateLocation());

//     // Obtain the driver's initial location and update it in the Firebase Realtime Database
//     _updateLocation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Driver Page'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Latitude: $_latitude'),
//             Text('Longitude: $_longitude'),
//           ],
//         ),
//       ),
//     );
//   }

//   // Obtain the driver's current location and update it in the Firebase Realtime Database
//   void _updateLocation() async {
//     Location location = Location();
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;

//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         return;
//       }
//     }

//     permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }

//     Position position = await Geolocator.getCurrentPosition();
//     print('helllooooo    ..........');
//     print(position.latitude);
//     print(position.longitude);
//     _latitude = position.latitude;
//     _longitude = position.longitude;
//     //_driverLocationRef.child('latitude').set(_latitude);
//     _driverLocationRef.child('latitude').set(_latitude).then((value) {
//       print('Location updated successfully!');
//     }).catchError((error) {
//       print('Error updating location: $error');
//     });

//     _driverLocationRef.child('longitude').set(_longitude);
//     Position positiondata = await Geolocator.getCurrentPosition();
//     print('helllooooo    ..........5656');
//     setState(() {
//       _latitude = positiondata.latitude;
//       _longitude = positiondata.longitude;
//       print('helllooooo    ..........5656,,,,SS');
//     }); // Update the UI with the new location data
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class DriverPage extends StatefulWidget {
  const DriverPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DriverPageState createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  String driverId = 'driver1'; // Change this to the driver's ID
  late DocumentReference<Map<String, dynamic>> _driverLocationRef;
  double _latitude = 0.0;
  double _longitude = 0.0;

  @override
  void initState() {
    super.initState();

    _driverLocationRef =
        FirebaseFirestore.instance.collection('locations').doc(driverId);

    Timer.periodic(const Duration(seconds: 3), (Timer t) => _updateLocation());
    _updateLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Latitude: $_latitude'),
            Text('Longitude: $_longitude'),
          ],
        ),
      ),
    );
  }

  Future<void> _updateLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

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

    Position position = await Geolocator.getCurrentPosition();
    _latitude = position.latitude;
    _longitude = position.longitude;

    try {
      await _driverLocationRef.set({
        'latitude': _latitude,
        'longitude': _longitude,
      });
      print('Location updated successfully!');
    } catch (error) {
      print('Error updating location: $error');
    }

    Position positionData = await Geolocator.getCurrentPosition();
    setState(() {
      _latitude = positionData.latitude;
      _longitude = positionData.longitude;
    });
  }
}

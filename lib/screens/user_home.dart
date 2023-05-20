import 'package:campus_connect/reusable_widgets/reusable_widget.dart';
import 'package:campus_connect/screens/display_map.dart';
//import 'package:campus_connect/screens/driver_screen.dart';
import 'package:campus_connect/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key, required this.userName});

  final String userName;

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  Map<String, dynamic> data = {};
  LatLng sourceLoc = LatLng(0, 0);

  Future<void> _fetchData() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('user')
        .where('Email', isEqualTo: widget.userName)
        .get();

    // Access the data from the first document returned by the query
    data = snapshot.docs.first.data();

    getLocationFromPlaceName(data['toStop']);
  }

  Future<void> getLocationFromPlaceName(String placeName) async {
    try {
      // Use the Geocoding API to get the location data for the specified place name
      final locations = await locationFromAddress(placeName);

      // Extract the latitude and longitude from the location data
      final latitude = locations.first.latitude;
      final longitude = locations.first.longitude;

      // Return a new LatLng object with the latitude and longitude values
      sourceLoc = LatLng(latitude, longitude);
      print("000000000000000000000000000000000000000000000$sourceLoc");
    } catch (e) {
      // Handle any errors that may occur during the geocoding process
      print(e);
    }
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(data);
    print("1111111111111111111111111111111111111111111111111$sourceLoc");
    print("99999999999999999999999999999999999999999999999${data['driverID']}");
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Campus Connect",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4"),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                button(context, "Map", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DisplayMap(
                              driverID: data['driverID'], source: sourceLoc)));
                }), /*
                const SizedBox(
                  height: 10,
                ),
                button(context, "Driver", () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DriverPage()));
                }),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}

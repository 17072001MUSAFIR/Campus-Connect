import 'package:campus_connect/reusable_widgets/reusable_widget.dart';
import 'package:campus_connect/screens/bus_details.dart';
import 'package:campus_connect/screens/driver_details.dart';
import 'package:campus_connect/screens/driver_screen.dart';
import 'package:campus_connect/screens/user_details.dart';
import 'package:campus_connect/utils/color_utils.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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
                button(context, "Bus", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BusDetails()));
                }),
                const SizedBox(
                  height: 10,
                ),
                button(context, "Driver", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DriverDetails()));
                }),
                const SizedBox(
                  height: 10,
                ),
                button(context, "User", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserDetails()));
                }),
                const SizedBox(
                  height: 10,
                ),
                button(context, "Driver", () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DriverPage()));
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

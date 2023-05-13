import 'package:campus_connect/firebase_options.dart';
import 'package:campus_connect/screens/bus_details.dart';
import 'package:campus_connect/screens/display_map.dart';
import 'package:campus_connect/screens/home_screen.dart';
import 'package:campus_connect/screens/signin_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const SignInScreen(),
      home: const DisplayMap(),
    );
  }
}

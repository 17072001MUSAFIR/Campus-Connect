import 'package:campus_connect/reusable_widgets/reusable_widget.dart';
import 'package:campus_connect/screens/home_screen.dart';
import 'package:campus_connect/screens/signup_screen.dart';
import 'package:campus_connect/screens/user_home.dart';
import 'package:campus_connect/utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();

  String? selectedRole;
  List<String> role = ["User", "Driver"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                logoWidget("assets/images/logo.png"),
                const SizedBox(
                  height: 30,
                ),
                textField("Enter Email ID", Icons.verified_user, false,
                    emailTextController),
                const SizedBox(
                  height: 20,
                ),
                textField("Enter Password", Icons.lock_outline, true,
                    passwordTextController),
                const SizedBox(height: 20),
                // textField1("Enter Bus ID", Icons.stop, TextInputType.number,
                //     busIdController),
                DropdownButtonFormField(
                  items: role.map((s) {
                    return DropdownMenuItem(
                      value: s,
                      child: Text(s.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value.toString();
                    });
                  },
                  style: TextStyle(color: Colors.black.withOpacity(0.9)),
                  decoration: InputDecoration(
                    labelText: "Select Role",
                    labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                            width: 0, style: BorderStyle.none)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                button(context, "Sign In", () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: emailTextController.text,
                          password: passwordTextController.text)
                      .then((value) {
                    if (emailTextController.text == "admin@gmail.com" &&
                        passwordTextController.text == "admin1") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserHome(
                                  userName: emailTextController.text)));
                    }
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                }),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have account? ",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

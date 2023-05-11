import 'package:campus_connect/reusable_widgets/reusable_widget.dart';
import 'package:campus_connect/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final CollectionReference users =
      FirebaseFirestore.instance.collection("user");

  final CollectionReference drivers =
      FirebaseFirestore.instance.collection("driver");

  final CollectionReference buses =
      FirebaseFirestore.instance.collection("bus");

  TextEditingController driverIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController busIdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController feesController = TextEditingController();
  TextEditingController stopController = TextEditingController();

  String? selectedDept;
  List<String> depts = ["CSE", "CE", "ME", "EEE", "EC", "RB", "AI", "MBA"];

  String? selectedSem;
  List<int> sem = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  String? selectedBusId;
  List<List> busIds = [];

  String? selectedDriverId;
  List<List> driverIds = [];

  Future<List<DocumentSnapshot>> getAllBusData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection('bus').get();
    List<DocumentSnapshot> documents = querySnapshot.docs;
    busIds = [];
    for (var doc in documents) {
      busIds.add([doc['Id'], doc['fromStop'], doc['toStop']]);
    }
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> getAllDriverData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection('driver').get();
    List<DocumentSnapshot> documents = querySnapshot.docs;
    driverIds = [];
    for (var doc in documents) {
      driverIds.add([doc['Id'], doc['name']]);
    }
    return querySnapshot.docs;
  }

  int max = 0;

  void increment() async {
    final QuerySnapshot querySnapshot =
        await users.orderBy('Id', descending: true).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      max = querySnapshot.docs.first['Id'] as int;
    }
  }

  Future<void> _create() async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  right: 20,
                  left: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Add Driver",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  textField1("Enter the Name", Icons.stop, TextInputType.text,
                      nameController),
                  const SizedBox(height: 20),
                  textField1("Enter Contact Number", Icons.stop,
                      TextInputType.text, contactController),
                  const SizedBox(height: 20),
                  textField1("Enter Email ID", Icons.stop, TextInputType.text,
                      emailController),
                  const SizedBox(height: 20),
                  // textField1("Enter Bus ID", Icons.stop, TextInputType.number,
                  //     busIdController),
                  DropdownButtonFormField(
                    items: depts.map((dept) {
                      return DropdownMenuItem(
                        value: dept,
                        child: Text(dept),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDept = value;
                      });
                    },
                    style: TextStyle(color: Colors.black.withOpacity(0.9)),
                    decoration: InputDecoration(
                      labelText: "Select the Department",
                      labelStyle:
                          TextStyle(color: Colors.black.withOpacity(0.9)),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.black.withOpacity(0.3),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // textField1("Enter Bus ID", Icons.stop, TextInputType.number,
                  //     busIdController),
                  DropdownButtonFormField(
                    items: sem.map((s) {
                      return DropdownMenuItem(
                        value: s,
                        child: Text(s.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSem = value.toString();
                      });
                    },
                    style: TextStyle(color: Colors.black.withOpacity(0.9)),
                    decoration: InputDecoration(
                      labelText: "Select the Semester",
                      labelStyle:
                          TextStyle(color: Colors.black.withOpacity(0.9)),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.black.withOpacity(0.3),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // textField1("Enter Bus ID", Icons.stop, TextInputType.number,
                  //     busIdController),
                  DropdownButtonFormField(
                    items: busIds.map((busId) {
                      return DropdownMenuItem(
                        value: busId[0],
                        child: Text("${busId[0]} : ${busId[1]} - ${busId[2]}"
                            .toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBusId = value.toString();
                      });
                    },
                    style: TextStyle(color: Colors.black.withOpacity(0.9)),
                    decoration: InputDecoration(
                      labelText: "Select the Bus",
                      labelStyle:
                          TextStyle(color: Colors.black.withOpacity(0.9)),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.black.withOpacity(0.3),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // textField1("Enter Bus ID", Icons.stop, TextInputType.number,
                  //     busIdController),
                  DropdownButtonFormField(
                    items: driverIds.map((driverId) {
                      return DropdownMenuItem(
                        value: driverId[0],
                        child: Text(driverId[1]),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDriverId = value.toString();
                      });
                    },
                    style: TextStyle(color: Colors.black.withOpacity(0.9)),
                    decoration: InputDecoration(
                      labelText: "Select the Driver",
                      labelStyle:
                          TextStyle(color: Colors.black.withOpacity(0.9)),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.black.withOpacity(0.3),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  textField1("Enter the Fees", Icons.stop, TextInputType.number,
                      feesController),
                  const SizedBox(height: 20),
                  textField1("Enter the Stop", Icons.stop, TextInputType.text,
                      stopController),
                  const SizedBox(
                    height: 20,
                  ),
                  // button(context, "Create", onTap)
                  ElevatedButton(
                      onPressed: () async {
                        final String name = nameController.text;
                        final String contact = contactController.text;
                        final String emaiil = emailController.text;
                        final int? fees = int.tryParse(feesController.text);
                        final String stop = stopController.text;
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailController.text, password: "123456")
                            .then((value) {
                          print("Created New Account");
                        }).onError((error, stackTrace) {
                          print("Error ${error.toString()}");
                        });
                        await users.add({
                          "Id": max + 1,
                          "Name": name,
                          "Contact": contact,
                          "Email": emaiil,
                          "Department": selectedDept,
                          "Semester": selectedSem,
                          "Fees": fees,
                          "Balance": fees,
                          "busId": selectedBusId,
                          "driverId": selectedDriverId,
                          "fromStop": "Adi Shankara",
                          "toStop": stop
                        });
                        nameController.text = '';
                        contactController.text = '';
                        emailController.text = '';
                        feesController.text = '';
                        stopController.text = '';
                        Navigator.of(context).pop();
                      },
                      child: const Text("Create"))
                ],
              ),
            ),
          );
        });
  }

  Future<void> update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      driverIdController.text = documentSnapshot['Id'].toString();
      nameController.text = documentSnapshot['name'];
      contactController.text = documentSnapshot['contact'];
      busIdController.text = documentSnapshot['busId'].toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                right: 20,
                left: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Update Bus",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                textField1("Enter the Name", Icons.stop, TextInputType.text,
                    nameController),
                const SizedBox(height: 20),
                textField1("Enter The Contact", Icons.stop, TextInputType.text,
                    contactController),
                const SizedBox(height: 20),
                textField1("Enter the Bus ID", Icons.perm_identity,
                    TextInputType.number, busIdController),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      final int? driverId =
                          int.tryParse(driverIdController.text);
                      final String name = nameController.text;
                      final String contact = contactController.text;
                      final int? busId = int.tryParse(busIdController.text);

                      if (driverId != null) {
                        await drivers.doc(documentSnapshot!.id).update({
                          "Id": driverId,
                          "name": name,
                          "contact": contact,
                          "busId": busId
                        });
                        driverIdController.text = '';
                        nameController.text = '';
                        contactController.text = '';
                        busIdController.text = '';
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text("Update"))
              ],
            ),
          );
        });
  }

  Future<void> delete(String busID) async {
    await drivers.doc(busID).delete();

    // for snackBar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You Have Successfully Deleted a Driver")));
  }

  @override
  Widget build(BuildContext context) {
    getAllBusData();
    getAllDriverData();
    increment();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Campus Connect - Bus Details",
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
        child: StreamBuilder(
          stream: users.snapshots(),
          builder: (
            context,
            AsyncSnapshot<QuerySnapshot> streamSnapshot,
          ) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    color: const Color.fromARGB(255, 88, 136, 190),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 17,
                        backgroundColor: const Color.fromARGB(255, 26, 226, 76),
                        child: Text(
                          documentSnapshot['Id'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      title: Text(
                        documentSnapshot['Name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(documentSnapshot['Department']),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              color: Colors.black,
                              onPressed: () => update(documentSnapshot),
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              color: Colors.black,
                              onPressed: () => delete(documentSnapshot.id),
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        backgroundColor: const Color.fromARGB(255, 88, 136, 190),
        child: const Icon(Icons.add),
      ),
    );
  }
}

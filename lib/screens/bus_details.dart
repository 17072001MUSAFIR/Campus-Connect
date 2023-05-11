import 'package:campus_connect/reusable_widgets/reusable_widget.dart';
import 'package:campus_connect/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BusDetails extends StatefulWidget {
  const BusDetails({Key? key}) : super(key: key);

  @override
  State<BusDetails> createState() => _BusDetailsState();
}

class _BusDetailsState extends State<BusDetails> {
  final CollectionReference buses =
      FirebaseFirestore.instance.collection("bus");

  TextEditingController idController = TextEditingController();
  TextEditingController fromStopController = TextEditingController();
  TextEditingController toStopController = TextEditingController();

  int max = 0;

  void increment() async {
    final QuerySnapshot querySnapshot =
        await buses.orderBy('Id', descending: true).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      max = querySnapshot.docs.first['Id'] as int;
    }
  }

  Future<void> _create() async {
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
                    "Add Bus",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                textField1("Enter From Stop", Icons.stop, TextInputType.text,
                    fromStopController),
                const SizedBox(height: 20),
                textField1("Enter To Stop", Icons.stop, TextInputType.text,
                    toStopController),
                const SizedBox(height: 20),
                const SizedBox(
                  height: 20,
                ),
                // button(context, "Create", onTap)
                ElevatedButton(
                    onPressed: () async {
                      final String fromStop = fromStopController.text;
                      final String toStop = toStopController.text;
                      await buses.add({
                        "Id": max + 1,
                        "fromStop": fromStop,
                        "toStop": toStop
                      });
                      idController.text = '';
                      fromStopController.text = '';
                      toStopController.text = '';
                      Navigator.of(context).pop();
                    },
                    child: const Text("Create"))
              ],
            ),
          );
        });
  }

  Future<void> update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      idController.text = documentSnapshot['Id'].toString();
      fromStopController.text = documentSnapshot['fromStop'];
      toStopController.text = documentSnapshot['toStop'];
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
                textField1("Enter From Stop", Icons.stop, TextInputType.text,
                    fromStopController),
                const SizedBox(height: 20),
                textField1("Enter To Stop", Icons.stop, TextInputType.text,
                    toStopController),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      final int? id = int.tryParse(idController.text);
                      final String fromStop = fromStopController.text;
                      final String toStop = toStopController.text;
                      if (id != null) {
                        await buses.doc(documentSnapshot!.id).update(
                            {"Id": id, "fromStop": fromStop, "toStop": toStop});
                        idController.text = '';
                        fromStopController.text = '';
                        toStopController.text = '';
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
    await buses.doc(busID).delete();

    // for snackBar
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You Have Successfully Deleted a Bus")));
  }

  @override
  Widget build(BuildContext context) {
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
          stream: buses.snapshots(),
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
                        documentSnapshot['fromStop'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(documentSnapshot['toStop']),
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

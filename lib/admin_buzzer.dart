import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminBuzzer extends StatefulWidget {
  static const routeName = "admin";
  const AdminBuzzer({super.key});

  @override
  State<AdminBuzzer> createState() => AdminBuzzerState();
}

class AdminBuzzerState extends State<AdminBuzzer> {
  bool _isloading = false;
  List<Map<String, dynamic>> buzzers = [];
  final _firebaseDB = FirebaseDatabase.instance.ref("buzzer");
  @override
  void initState() {
    super.initState();
    _firebaseDB.onChildAdded.listen((event) async {
      final value = event.snapshot.value;
      if (value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> messageData = value;
        final teamName = messageData['team_name'];
        final time = messageData['time'];

        setState(() {
          buzzers.add({
            "team_name": teamName,
            "time": time,
          });
          buzzers.sort((map1, map2) => map1['time'].compareTo(map2['time']));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isloading
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 5,
                color: Colors.deepPurple,
              ),
            )
          : Center(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: buzzers.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: index == 0
                        ? Colors.green.shade600
                        : index == 1
                            ? Colors.amber
                            : index == 2
                                ? Colors.deepPurple
                                : Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          customText((index + 1).toString()),
                          customText(buzzers[index]["team_name"]),
                          customText(
                              buzzers[index]["time"].toString().substring(10)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          elevation: 15,
          backgroundColor: Colors.green.shade800,
        ),
        onPressed: () {
          setState(() {
            _isloading = true;
          });
          _firebaseDB.remove().then((value) {
            buzzers.clear();
            setState(() {
              _isloading = false;
            });
          });
        },
        icon: const Icon(
          Icons.refresh,
          color: Colors.white,
          size: 60,
        ),
        label: const Text(
          "Referesh",
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
          ),
        ),
      ),
    );
  }

  Widget customText(content) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 19,
      ),
    );
  }
}

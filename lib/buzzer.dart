// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';

class Buzzer extends StatefulWidget {
  const Buzzer({required this.teamName, super.key});
  final String teamName;
  @override
  State<Buzzer> createState() => _BuzzerState();
}

class _BuzzerState extends State<Buzzer> {
  bool _isClicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("Buzzer"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _isClicked ? Colors.red.shade200 : Colors.red.shade900,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(360),
            ),
          ),
          onPressed: () {
            setState(() {
              _isClicked = true;
            });
            FirebaseDatabase.instance.ref("buzzer").push().set({
              "team_name": widget.teamName,
              "time": DateTime.now().toString(),
            }).then(
              (value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BuzzerBottomSheet(),
                  ),
                ).then((value) {
                  setState(
                    () {
                      _isClicked = false;
                    },
                  );
                });
                // showModalBottomSheet(
                //   context: context,
                //   builder: (context) {
                //     return const BuzzerBottomSheet();
                //   },
                // ).then(
                //   (value) => setState(
                //     () {
                //       _isClicked = false;
                //     },
                //   ),
                // );
              },
            );
          },
          child: Container(
            height: 300,
            width: 300,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                "Click",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Copyright ©\t"),
            TextButton(
              onPressed: _launchUrl,
              child: const Text("Nediveil Technologies"),
            ),
          ],
        ),
      ),
    );
  }

  final _url = Uri.parse('https://www.nediveil.in');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }
}

Widget whiteText(data) {
  return Text(
    data,
    style: const TextStyle(
      fontSize: 19,
      color: Colors.white,
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

class BuzzerBottomSheet extends StatefulWidget {
  const BuzzerBottomSheet({super.key});

  @override
  State<BuzzerBottomSheet> createState() => BuzzerBottommSheetState();
}

class BuzzerBottommSheetState extends State<BuzzerBottomSheet> {
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
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Leader board"),
        // leading: const SizedBox(),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Next "),
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: buzzers.length,
          itemBuilder: (context, index) {
            return Card(
              color: index == 0
                  ? Colors.red
                  : index == 1
                      ? Colors.yellow
                      : Colors.blue,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    customText((index + 1).toString()),
                    customText(buzzers[index]["team_name"]),
                    customText(buzzers[index]["time"].toString().substring(10)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

final _url = Uri.parse('https://www.nediveil.in');
Future<void> _launchUrl() async {
  if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $_url');
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      width: MediaQuery.of(context).size.width * 0.6,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage("assets/nv.png"),
                ),
                Text(
                  "Our services",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                whiteText("1. Web Development"),
                whiteText("2. App Development"),
                whiteText("3. Bussiness Analysis"),
                whiteText("4. 3D Designing"),
                whiteText("5. Search Engine optimization"),
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: _launchUrl,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28.0,
                        vertical: 10,
                      ),
                      child: Text(
                        "visit us",
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(child: SizedBox()),
                Padding(
                  padding: const EdgeInsets.only(bottom: 28.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      whiteText("Copyright ©\t"),
                      whiteText("Nediveil Technologies"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

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
  Future<bool> isNameUsed(String name, DatabaseReference buzzerRef) async {
    final nameQuery = buzzerRef.orderByChild("team_name").equalTo(name);

    final DatabaseEvent snapshot = await nameQuery.once();

    return snapshot.snapshot.exists;
  }

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
          onPressed: () async {
            setState(() {
              _isClicked = true;
            });

            final database = FirebaseDatabase.instance;
            final buzzerRef = database.ref("buzzer");

            // Check if the name "hi" is already used.
            final bool isUsed = await isNameUsed(widget.teamName, buzzerRef);

            if (isUsed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Wait for next Question"),
                ),
              );
            } else {
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
            }
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
      fontSize: 12,
      color: Colors.white,
    ),
  );
}

Widget customText(content) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Text(
      content,
      style: const TextStyle(
        fontSize: 15,
      ),
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
          buzzers.sort((map1, map2) => map1['time'].compareTo(map2['time']));
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
                    Expanded(child: customText(buzzers[index]["team_name"])),
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
          SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        child: Image(
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width * 0.5,
                          fit: BoxFit.fill,
                          image: AssetImage("assets/nv.png"),
                        ),
                      ),
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
                            horizontal: 19.0,
                            vertical: 5,
                          ),
                          child: Text(
                            "visit us",
                            style: TextStyle(
                              color: Colors.purple,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 28.0,
                          right: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            whiteText("Copyright ©\t"),
                            whiteText("Nediveil Technologies"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

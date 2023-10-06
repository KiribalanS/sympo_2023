import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sympo_gova/buzzer.dart';

class ScoreCard extends StatefulWidget {
  const ScoreCard({super.key});

  @override
  State<ScoreCard> createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {
  List<Map<String, dynamic>> scorecard = [];
  final _firebaseDB = FirebaseDatabase.instance.ref("scorecard");
  @override
  void initState() {
    super.initState();

    _firebaseDB.onChildAdded.listen((event) async {
      final value = event.snapshot.value;
      // print("object");
      if (value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> messageData = value;
        final teamName = messageData['team_name'];
        final score = messageData['score'];

        setState(() {
          scorecard.add({
            "team_name": teamName,
            "score": score,
          });
          scorecard
              .sort((map1, map2) => map1['score'].compareTo(map2['score']));
          scorecard = scorecard.reversed.toList();
        });
      }
    });
    _firebaseDB.onChildChanged.listen((event) async {
      final value = event.snapshot.value;
      // print("object");
      if (value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> messageData = value;
        final teamName = messageData['team_name'];
        final score = messageData['score'];

        setState(() {
          scorecard.removeWhere((element) => element["team_name"] == teamName);
          scorecard.add({
            "team_name": teamName,
            "score": score,
          });
          scorecard
              .sort((map1, map2) => map1['score'].compareTo(map2['score']));
          scorecard = scorecard.reversed.toList();
        });
      }
    });

    _firebaseDB.onChildRemoved.listen((event) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade100,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade300,
        title: const Text(
          "Score Card",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.deepOrange.shade200,
            child: Row(
              children: [
                customText("S.no"),
                Expanded(child: Center(child: customText("Team Name"))),
                customText("Score"),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: scorecard.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                  child: Card(
                    color: index == 0
                        ? Colors.green.shade600
                        : index == 1
                            ? Colors.amber
                            : index == 2
                                ? Colors.deepPurple.shade300
                                : Colors.blue,
                    child: Row(
                      children: [
                        customText((index + 1).toString()),
                        Expanded(
                          child: Center(
                            child: customText(
                              scorecard[index]["team_name"],
                            ),
                          ),
                        ),
                        customText(
                          scorecard[index]["score"].toString(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget customText(text) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      text,
      style: const TextStyle(fontSize: 19),
      textAlign: TextAlign.center,
    ),
  );
}

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sympo_gova/buzzer.dart';

class AddScore extends StatefulWidget {
  const AddScore({super.key});

  @override
  State<AddScore> createState() => _AddScoreState();
}

class _AddScoreState extends State<AddScore> {
  List<Map<String, dynamic>> scorecard = [];
  final _firebaseDB = FirebaseDatabase.instance.ref("scorecard");
  @override
  void initState() {
    super.initState();

    _firebaseDB.onChildAdded.listen((event) async {
      final value = event.snapshot.value;
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

  void setScore(String name, int score) async {
    final nodeRef = _firebaseDB.child(name);

    nodeRef.update({
      'score': score,
    });

    // try {} catch (e) {
    //   print(e.toString());
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(
    //         e.toString(),
    //       ),
    //     ),
    //   );
    //   throw FirebaseException(plugin: "plugin");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: Colors.indigo.shade100,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text(
          "ScoreCard",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.lightGreen,
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
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                            child: ElevatedButton(
                              onPressed: () {
                                setScore(
                                  scorecard[index]["team_name"],
                                  scorecard[index]["score"] + 1,
                                );
                                Navigator.pop(context);
                                setState(() {});
                              },
                              child: SizedBox(
                                height: 75,
                                width: 200,
                                child: Center(
                                    child: FittedBox(
                                        fit: BoxFit.contain,
                                        child:
                                            customText("Tap to add score!"))),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Card(
                      color: index == 0
                          ? Colors.green.shade600
                          : index == 1
                              ? Colors.amber
                              : index == 2
                                  ? Colors.deepPurple
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

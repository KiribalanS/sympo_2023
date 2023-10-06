import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddScore extends StatefulWidget {
  const AddScore({super.key});

  @override
  State<AddScore> createState() => _AddScoreState();
}

class _AddScoreState extends State<AddScore> {
  bool _isloading = false;
  List<Map<String, dynamic>> scorecard = [];
  final _firebaseDB = FirebaseDatabase.instance.ref("scorecard");
  @override
  void initState() {
    super.initState();
    _firebaseDB.onChildChanged.listen((event) async {
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
        });
      }
    });
  }

  void setScore(String name, int score) {
    _firebaseDB.child(name).set({"score": score});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ScoreCard"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: scorecard.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
          );
        },
      ),
    );
  }
}

Widget customText(text) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      text,
      style: TextStyle(fontSize: 19),
      textAlign: TextAlign.center,
    ),
  );
}

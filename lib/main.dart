import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sympo_gova/add_score.dart';
import 'package:sympo_gova/admin_buzzer.dart';
import 'package:sympo_gova/buzzer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sympo_gova/score_card.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCE2DcEfYquWCCoWVj6_GGEFv4AXS8nMgc",
      authDomain: "symposium-2023-1b5a5.firebaseapp.com",
      projectId: "symposium-2023-1b5a5",
      storageBucket: "symposium-2023-1b5a5.appspot.com",
      messagingSenderId: "503434906554",
      appId: "1:503434906554:web:d521712867108800b7eb83",
      measurementId: "G-D8VVRCM6JD",
      databaseURL: "https://symposium-2023-1b5a5-default-rtdb.firebaseio.com/",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const JoinCode(),
      initialRoute: "/",
      routes: {
        "/refresh": (context) => const AdminBuzzer(),
        "/part": (context) => const BuzzerBottomSheet(),
        '/buzzer': (context) => const Buzzer(teamName: "#thirutu_kutty"),
        '/score': (context) => const ScoreCard(),
        '/as': (context) => const AddScore(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final teamName = TextEditingController();
  final form = GlobalKey<FormState>();

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.5,
                      image: const AssetImage("assets/nv2.png"),
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Form(
                          key: form,
                          child: TextFormField(
                            onFieldSubmitted: (value) {
                              if (form.currentState!.validate()) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Buzzer(teamName: teamName.text),
                                  ),
                                );
                              }
                            },
                            controller: teamName,
                            validator: (value) {
                              if (value == null || value == "") {
                                return "Please enter a Team Name";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Enter Team Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (form.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            FirebaseDatabase.instance
                                .ref("scorecard")
                                .child(teamName.text)
                                .set({
                              "team_name": teamName.text,
                              "score": 0,
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Buzzer(teamName: teamName.text),
                              ),
                            );
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        child: const SizedBox(
                          height: 50,
                          width: 150,
                          child: Text(
                            "Next",
                            style: TextStyle(
                              fontSize: 30,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Copyright ©\t"),
                        TextButton(
                          onPressed: _launchUrl,
                          child: Text("Nediveil Technologies"),
                        ),
                      ],
                    ),
                  ],
                ),
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

class JoinCode extends StatefulWidget {
  const JoinCode({super.key});

  @override
  State<JoinCode> createState() => _JoinCodeState();
}

class _JoinCodeState extends State<JoinCode> {
  final join = GlobalKey<FormState>();
  final code = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.5,
                image: const AssetImage("assets/nv2.png"),
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Form(
                    key: join,
                    child: TextFormField(
                      onFieldSubmitted: (_) {
                        if (join.currentState!.validate()) {
                          if (code.text == "cse") {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyHomePage(
                                    title: 'NediVeil Technologies Buzzer'),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Card(
                                  child: Center(
                                    child: ElevatedButton(
                                      child: const Padding(
                                        padding: EdgeInsets.all(19.0),
                                        child: Text(
                                          "No Rooms found!\nTap to Close",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }
                      },
                      controller: code,
                      validator: (value) {
                        if (value == null || value == "") {
                          return "Please enter a code";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Enter Code",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (join.currentState!.validate()) {
                      if (code.text == "cse") {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyHomePage(
                                title: 'NediVeil Technologies Buzzer'),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Card(
                              child: Center(
                                child: ElevatedButton(
                                  child: const Padding(
                                    padding: EdgeInsets.all(19.0),
                                    child: Text(
                                      "No Rooms found!\nTap to Close",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }
                  },
                  child: const SizedBox(
                    height: 50,
                    width: 150,
                    child: Text(
                      "Join",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Copyright ©\t"),
                  TextButton(
                    onPressed: _launchUrl,
                    child: Text("Nediveil Technologies"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

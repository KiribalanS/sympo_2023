import 'package:flutter/material.dart';
import 'package:sympo_gova/admin_buzzer.dart';
import 'package:sympo_gova/buzzer.dart';
import 'package:firebase_core/firebase_core.dart';
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
      home: const MyHomePage(title: 'NediVeil Technologies Buzzer'),
      initialRoute: "/",
      routes: {
        "/admin": (context) => const AdminBuzzer(),
        "/part": (context) => BuzzerBottomSheet(),
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
  bool _isLoading = false;
  final teamName = TextEditingController();
  final form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 5,
                color: Colors.deepPurple,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Form(
                      key: form,
                      child: TextFormField(
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
                        // setState(() {
                        //   _isLoading = true;
                        // });
                        // FirebaseDatabase.instance
                        //     .ref("paticipants")
                        //     .push()
                        //     .set(teamName.text.trim())
                        //     .then((value) {
                        //   setState(() {
                        //     _isLoading = false;
                        //   });
                        // });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Buzzer(teamName: teamName.text),
                          ),
                        );
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Copyright ©\t"),
                    TextButton(
                      onPressed: _launchUrl,
                      child: const Text("Nediveil Technologies"),
                    ),
                  ],
                ),
              ],
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

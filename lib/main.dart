import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//pub.dev
import 'package:hive_flutter/hive_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:typetest/home.dart';
import 'package:typetest/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC_NiiMlP9Iw_45-yrXRznWf1uzRRfANM8",
      authDomain: "speedyfingers-web.firebaseapp.com",
      projectId: "speedyfingers-web",
      storageBucket: "speedyfingers-web.appspot.com",
      messagingSenderId: "325851380353",
      appId: "1:325851380353:web:234aac927852a6d3d16b80",
      measurementId: "G-BJWSHJ7MV6",
    ),
  );

  await Hive.initFlutter();
  // ignore: unused_local_variable
  var box = await Hive.openBox('highscores');
  // ignore: unused_local_variable
  var box2 = await Hive.openBox('prevTestsWpms');
  // ignore: unused_local_variable
  var box3 = await Hive.openBox('missedWordCounters');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}

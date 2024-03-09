import "package:capp/firebase_options.dart";
import "package:capp/themes/light_mode.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:capp/auth/auth_gate.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: lightMode, 
    );  
  }
}
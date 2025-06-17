import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'login_screen.dart'; // Tela inicial de login

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCjfaK4sKnxlIP-q_5qNr4JnWrUle8MwcQ",
        authDomain: "recip-13f9c.firebaseapp.com",
        projectId: "recip-13f9c",
        storageBucket: "recip-13f9c.appspot.com",
        messagingSenderId: "140229643080",
        appId: "1:140229643080:web:1344ee6a932464f480017d",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const RecipApp());
}

class RecipApp extends StatelessWidget {
  const RecipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recip',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.brown[50],
        fontFamily: 'Georgia',
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(), // Tela inicial
    );
  }
}

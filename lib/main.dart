import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:neobank/firebase_options.dart';
import 'package:neobank/login_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Neobank',
        theme: ThemeData(),
        home: SafeArea(child: LoginHandler()));
  }
}

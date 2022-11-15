import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neobank/auth/auth_page.dart';
import 'package:neobank/pages/main_page.dart';
import 'package:neobank/pages/route_kyc.dart';

class LoginHandler extends StatefulWidget {
  const LoginHandler({super.key});

  @override
  State<LoginHandler> createState() => _LoginHandlerState();
}

class _LoginHandlerState extends State<LoginHandler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.idTokenChanges(),
          builder: (context, snapshot) {
            //print(snapshot.hasData);
            if (snapshot.connectionState != ConnectionState.waiting) {
              if (snapshot.hasData) {
                return RouteKYC();
              } else {
                return AuthPage();
              }
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}

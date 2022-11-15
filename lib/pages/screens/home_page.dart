// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:neobank/pages/utils/neobutton.dart';

import 'HomePage/FrontPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserDetails();
  }

  final user = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic>? _userDetails;
  Future<void> _getUserDetails() async {
    FirebaseFirestore.instance
        .collection('account')
        .doc(user.uid)
        .get()
        .then((value) {
      setState(() {
        _userDetails = value.data();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            FrontCard(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(50)),
                        // height: 100,
                        width: 50,
                        child: IconButton(
                          onPressed: () {},
                          color: Colors.blue,
                          icon: Icon(FlutterRemix.user_add_line,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text("Add accounts")
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(50)),
                        // height: 100,
                        width: 50,
                        child: IconButton(
                          onPressed: () {},
                          color: Colors.blue,
                          icon: Icon(FlutterRemix.bank_card_line,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text("View balance")
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(50)),
                        // height: 100,
                        width: 50,
                        child: IconButton(
                          onPressed: () {},
                          color: Colors.blue,
                          icon: Icon(FlutterRemix.money_dollar_circle_line,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text("Buy Assets")
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

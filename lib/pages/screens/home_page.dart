import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neobank/util/create_stellar_account.dart';

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
    String bal = '';
    return Center(
        child: Container(
            child: Row(
      children: [
        TextButton(
          child: bal.isEmpty ? Text("check Balance") : Text(bal),
          onPressed: () async {
            final bal1 = await StellarFunctions.checkBalance(
                _userDetails!['secret_key']);
            print(bal1);
            setState(() {
              bal = bal1;
            });
          },
        ),
        TextButton(
          child: Text("get 100 inr"),
          onPressed: () async {
            //print(_userDetails!['secret_key']);
            String res = await StellarFunctions.transferMoney(
                '100', _userDetails!['secret_key']);
            //print(res);
          },
        ),
      ],
    )));
  }
}

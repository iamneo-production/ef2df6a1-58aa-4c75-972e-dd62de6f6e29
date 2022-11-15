import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

import '../../utils/neobutton.dart';

class FrontCard extends StatelessWidget {
  const FrontCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 236, 229, 251),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              "Quick Pay",
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: PButton(
                    desc: "Account transfer",
                    icon: FlutterRemix.user_shared_line,
                  ),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {},
                  child: PButton(
                    desc: "Bank transfer ",
                    icon: FlutterRemix.bank_line,
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

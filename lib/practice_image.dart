import 'package:flutter/material.dart';

class PracticeImage extends StatefulWidget {
  const PracticeImage({super.key});

  @override
  State<PracticeImage> createState() => _PracticeImageState();
}

class _PracticeImageState extends State<PracticeImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Practice Task")),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Image.asset(
            "assets/images/virat.png",
            height: 100,
            width: 200,
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
         CircleAvatar(
           radius: 30,
           backgroundImage: AssetImage("assets/images/virat.png"),
         )
        ],
      ),
    );
  }
}

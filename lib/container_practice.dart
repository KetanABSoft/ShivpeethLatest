import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PracticeContainer extends StatefulWidget {
  const PracticeContainer({super.key});

  @override
  State<PracticeContainer> createState() => _PracticeContainerState();
}

class _PracticeContainerState extends State<PracticeContainer> {
  @override
  void initState() {
    super.initState();
    // FirebaseMessaging.onMessage.listen((message) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text(message.data["MyName"].toString()),
    //       duration: Duration(seconds: 10),
    //     backgroundColor: Colors.green,
    //   ));
    //   print("Messege Recieved! ${message.notification!.title}");
    // });
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text("App is Open By Notification"),
    //     duration: Duration(seconds: 10),
    //     backgroundColor: Colors.green,
    //   ));
    //   print("Messege Recieved! ${message.notification!.title}");
    // });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Container Practice"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              CircleAvatar(
                radius: 30,
              ),
              SizedBox(
                width: 60,
              ),
              Column(
                children: [
                  Text(
                    "Parth",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "Hiii",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              SizedBox(
                width: 90,
              ),
              Column(
                children: [
                  Text(
                    "2.23 AM",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "9",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 30,
            ),
            title: Text(
              "Parth",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              "Hiii",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            trailing: Text(
              "2.23 AM",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 150,
            width: 300,
            child: Card(
              elevation: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hellow",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 30),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 150,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(11)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Satara",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 30),
                ),
                Text("Pune",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 30),),
              ],
            ),
          )
        ],
      ),
    );
  }
}

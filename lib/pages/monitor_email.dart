// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testing_pill_pal/classes/user.dart' as model;
import 'package:testing_pill_pal/components/error_display.dart';
import 'package:testing_pill_pal/components/my_button.dart';
import 'package:testing_pill_pal/components/my_textfield.dart';
import 'package:testing_pill_pal/pages/home_page.dart';
import 'package:testing_pill_pal/pages/page_view.dart';
import 'package:testing_pill_pal/providers/user_provider.dart';
import 'package:testing_pill_pal/services/firebase.dart';

import 'package:provider/provider.dart';

class MonitorEmailPage extends StatefulWidget {
  MonitorEmailPage({super.key});

  @override
  State<MonitorEmailPage> createState() => _MonitorEmailPageState();
}

class _MonitorEmailPageState extends State<MonitorEmailPage> {
  TextEditingController emailcontroller = TextEditingController();

  FirestoreService firestoreService = FirestoreService();

  void send(String email) {
    try {
      firestoreService.updateRequest(
          email: emailcontroller.text, requester_email: email);

      firestoreService.updateRequestedUsers(
          email: email, request_email: emailcontroller.text);

      Provider.of<UserProvider>(context, listen: false).refreshUser();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SliderPage(currentIndex: 1)),
      );
    } catch (e) {
      displayErrorMessage(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Who would you like to monitor?"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade400,
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  // const Color.fromARGB(47, 230, 236, 255),
                  const Color.fromARGB(44, 192, 203, 251),
                  Colors.grey.shade100, // End color
                ],
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    //logo
                    Image.asset(
                      'assets/monitor.png',
                      width: 300, // Adjust width
                      height: 300, // Adjust height
                      fit: BoxFit.cover, // Adjust how the image fits
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    MyTextfield(
                        hintText: "User Email",
                        isPassword: false,
                        controller: emailcontroller),

                    const SizedBox(
                      height: 25,
                    ),

                    MyButton(
                        onTap: () => send(user.email), text: "SEND REQUEST"),

                    const SizedBox(
                      height: 25,
                    ),

                    Text(
                      "You can start monitoring once the user approves your request.",
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

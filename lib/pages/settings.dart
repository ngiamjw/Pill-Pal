import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testing_pill_pal/auth/auth.dart';
import 'package:testing_pill_pal/auth/login_or_register.dart';
import 'package:testing_pill_pal/components/my_display_container.dart';
import 'package:testing_pill_pal/pages/home_page.dart';
import 'package:testing_pill_pal/pages/profile.dart';
import 'package:testing_pill_pal/providers/user_provider.dart';
import 'package:testing_pill_pal/services/firebase.dart';
import 'package:provider/provider.dart';
import 'package:testing_pill_pal/classes/user.dart' as model;
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController monitorcontroller = TextEditingController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService = FirestoreService();
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 65, 153, 230),
        title: Text('Settings'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(44, 192, 203, 251),
              Colors.grey.shade100, // End color
            ],
          ),
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Circle with abbreviated email
                      CircleAvatar(
                        radius: 30,
                        child: Text(
                          user.email.substring(0, 2).toUpperCase(),
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      SizedBox(width: 45),
                      // Full email
                      Text(
                        user.email,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),

                  // Logout box

                  MyDisplayContainer(
                      left: Text(
                        'Logout',
                        style: TextStyle(fontSize: 16),
                      ),
                      right: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade300,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  title:
                                      Text('Are you sure you want to logout?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'CANCEL',
                                        style: TextStyle(
                                            color: Colors.blue.shade400,
                                            fontSize: 18),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // Placeholder for logout action
                                        FirebaseAuth.instance.signOut();
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        await prefs.remove('email');
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => AuthPage()),
                                          (route) => false,
                                        );
                                      },
                                      child: Text(
                                        'YES',
                                        style: TextStyle(
                                            color: Colors.red.shade400,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Icon(Icons.logout, color: Colors.black))),

                  SizedBox(
                    height: 20,
                  ),

                  MyDisplayContainer(
                      left: Text(
                        'Monitor Users',
                        style: TextStyle(fontSize: 16),
                      ),
                      right: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade300,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  title: Center(
                                    child: Text(
                                      'User Email',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  content: TextField(
                                    controller: monitorcontroller,
                                    decoration: InputDecoration(
                                      hintText: 'Enter email',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 2),
                                    ),
                                  ),
                                  actions: [
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, bottom: 8.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.blue.shade400,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            // Add button action here
                                            firestoreService
                                                .updateRequestedUsers(
                                                    email: user.email,
                                                    request_email:
                                                        monitorcontroller.text);
                                            firestoreService.updateRequest(
                                                email: monitorcontroller.text,
                                                requester_email: user.email);

                                            Navigator.pop(context);
                                            monitorcontroller.clear();
                                          },
                                          child: Text(
                                            'ADD',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Icon(Icons.add, color: Colors.black))),

                  SizedBox(
                    height: 20,
                  ),

                  StreamBuilder<DocumentSnapshot>(
                    stream: firestoreService.getUserStream(user.email),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        var requestList = userData['request'] as List<dynamic>?;

                        if (requestList == null || requestList.isEmpty) {
                          return Container();
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "User Requests",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: requestList.length,
                                itemBuilder: (context, index) {
                                  var request = requestList[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: MyDisplayContainer(
                                      left: Text(request),
                                      right: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width:
                                                85, // Set width of Allow button
                                            child: ElevatedButton(
                                              onPressed: () {
                                                // TODO: Add allow action here
                                                firestoreService
                                                    .updatePermissions(
                                                        email: user.email,
                                                        request_email: request);

                                                firestoreService.removeRequest(
                                                    email: user.email,
                                                    requestEmail: request);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .colorScheme
                                                    .onSecondaryContainer, // Background color
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Rounded corners
                                                ),
                                              ),
                                              child: Text(
                                                'Allow',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                              width:
                                                  8), // Spacing between buttons
                                          SizedBox(
                                            width:
                                                85, // Set width of Reject button
                                            child: ElevatedButton(
                                              onPressed: () {
                                                // TODO: Add reject action here
                                                firestoreService.removeRequest(
                                                    email: user.email,
                                                    requestEmail: request);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .colorScheme
                                                    .onTertiaryContainer, // Background color
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Rounded corners
                                                ),
                                              ),
                                              child: Text(
                                                'Reject',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        }
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

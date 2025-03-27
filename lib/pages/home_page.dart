import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_pill_pal/classes/user.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing_pill_pal/classes/global_variables.dart';
import 'package:testing_pill_pal/components/first_box.dart';
import 'package:testing_pill_pal/components/medicine_container.dart';
import 'package:testing_pill_pal/components/my_display_container.dart';
import 'package:testing_pill_pal/pages/profile.dart';
import 'package:testing_pill_pal/pages/settings.dart';
import 'package:testing_pill_pal/services/firebase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

import '../providers/user_provider.dart';

class HomePage extends StatefulWidget {
  HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Assuming you pass the user's email to this widget
  final FirestoreService firestoreService = FirestoreService();

  String getTiming() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 10) {
      return "Morning";
    } else if (hour >= 10 && hour < 16) {
      return "Afternoon";
    } else if (hour >= 16 && hour < 18) {
      return "Evening";
    } else {
      return "Night";
    }
  }

  int calculateDoses(List<dynamic> medications, String time) {
    int sum = 0;

    for (var medication in medications) {
      List<dynamic> takenList = medication['taken'];

      for (var entry in takenList) {
        if (entry['value'] == true &&
            entry['time'] == time &&
            entry['dosages'] != null) {
          sum += entry['dosages'] as int;
        }
      }
    }

    return sum;
  }

  int currentIndex = 1;

  List<Map<String, dynamic>> medications = [];

  int x = 0;

  List<Color> _containerColors = [];
  List<int> x_list = [];
  Future<void> _changeColor(int index, bool value, String email,
      String user_email, int dose_index) async {
    if (email == user_email) {
      // Await the asynchronous call to Firestore service
      await firestoreService.updateMedicationTaken(
        email: user_email,
        index: index,
        value: !value,
        time: DateTime.now(),
        dose_index: dose_index,
      );
    }
  }

  Future<void> resetMedicationStatus(
      List<Map<String, dynamic>> medications, String email) async {
    DateTime today = DateTime.now();
    List<Map<String, dynamic>> og_medication =
        List.from(medications.map((e) => Map<String, dynamic>.from(e)));
    for (var medication in medications) {
      List<dynamic> taken = medication['taken'];

      for (var take in taken) {
        Timestamp time = take['date'];
        DateTime date = time.toDate(); // Convert Timestamp to DateTime

        // Check if the date does not match today's date
        if (date.year != today.year ||
            date.month != today.month ||
            date.day != today.day) {
          if (take['value'] == true) {
            take['value'] = false;
          }
        }
      }
    }
    // If there is an async call (e.g., Firestore update), use await here
    if (medications != og_medication) {
      await firestoreService.updateAllMedicationTaken(
          email: email, medications: medications);
      // Provider.of<UserProvider>(context, listen: false).refreshUser();
      // setState(() {});
    }
  }

  String? selectedEmail;
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    CounterModel counterModel = Provider.of<CounterModel>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 65, 153, 230),
        title: Text('Home'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
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
        child: StreamBuilder<DocumentSnapshot>(
            stream: firestoreService.getUserStream(user.email),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                var userData = snapshot.data!.data() as Map<String, dynamic>;
                List<dynamic> requested_users = [user.email];
                requested_users.addAll(userData['requested_users']);

                selectedEmail ??=
                    requested_users.isNotEmpty ? requested_users[0] : null;

                String time = getTiming();

                return ListView(
                  // Use a Stack here
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: Text(
                        "Good ${time}", // Call a function to get the current timing
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    if (requested_users.isNotEmpty)
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("currently viewing"),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton<String>(
                                value: selectedEmail,
                                items: requested_users
                                    .map<DropdownMenuItem<String>>((userEmail) {
                                  return DropdownMenuItem<String>(
                                    value: userEmail,
                                    child: Text(userEmail),
                                  );
                                }).toList(),
                                onChanged: (newEmail) {
                                  setState(() {
                                    selectedEmail = newEmail;
                                  });
                                },
                              ),
                            ),
                          ]),
                    if (selectedEmail != null)
                      StreamBuilder<DocumentSnapshot>(
                        stream: firestoreService.getUserStream(selectedEmail!),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            // Check if the error is a permission denied error
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Permission Required',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Please ensure you have the necessary permissions to access this data. Requested user must accept request in settings',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          // This will cause the entire widget to rebuild
                                        });
                                      },
                                      child: Text(
                                        'Retry',
                                        style: TextStyle(
                                            color: Colors.blue.shade600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          if (snapshot.hasData) {
                            var userData =
                                snapshot.data!.data() as Map<String, dynamic>;
                            medications = (userData['medications'] as List)
                                .map((item) => item as Map<String, dynamic>)
                                .toList();
                            return FutureBuilder<void>(
                              future: resetMedicationStatus(
                                  medications, selectedEmail!),
                              builder: (context, futureSnapshot) {
                                if (futureSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  developer.log("am waiting");
                                  return Center(
                                      child: CircularProgressIndicator());
                                }

                                if (futureSnapshot.hasError) {
                                  return Center(
                                      child: Text(
                                          'Error: ${futureSnapshot.error}'));
                                }
                                developer.log("this one built");
                                // Once the future is complete, return the updated UI
                                if (counterModel.containerColors.length !=
                                    medications.length) {
                                  _containerColors = List<Color>.filled(
                                    medications.length,
                                    Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  );
                                  counterModel.containerColors =
                                      _containerColors;
                                }

                                var permissions =
                                    userData['permissions'] as List<dynamic>;

                                int y = medications.fold<int>(
                                  0,
                                  (sum, med) {
                                    List<dynamic> takenList = med['taken'];
                                    int totalDosages = takenList.fold<int>(
                                      0,
                                      (subSum, entry) =>
                                          subSum +
                                          ((entry['time'] == time &&
                                                  entry['dosages'] != null)
                                              ? entry['dosages'] as int
                                              : 0),
                                    );
                                    return sum + totalDosages;
                                  },
                                );

                                int x = calculateDoses(medications, time);

                                if (x == 0 && y == 0) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 60,
                                      ),
                                      Text(
                                        "No ${time} medication",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Image.asset(
                                        'assets/caretaker.png',
                                        width: 300, // Adjust width
                                        height: 300, // Adjust height
                                        fit: BoxFit
                                            .cover, // Adjust how the image fits
                                      ),
                                      Text(
                                          "Click on profile to add medication"),
                                    ],
                                  );
                                }

                                if ((permissions.contains(user.email) ||
                                        user.email == selectedEmail) &&
                                    medications.isNotEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        FirstBox(x: x, y: y),
                                        const SizedBox(height: 25),
                                        ListView.builder(
                                          itemCount: medications.length,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, medIndex) {
                                            var med = medications[medIndex];
                                            List<dynamic> takenList =
                                                med['taken'];

                                            // Filter entries matching the selected time
                                            List<Map<String, dynamic>>
                                                matchingTaken = takenList
                                                    .where((entry) =>
                                                        entry['time'] == time)
                                                    .toList()
                                                    .cast<
                                                        Map<String, dynamic>>();

                                            if (matchingTaken.isEmpty)
                                              return SizedBox.shrink();

                                            return Column(
                                              children:
                                                  matchingTaken.map((entry) {
                                                int takenIndex =
                                                    takenList.indexOf(entry);
                                                return GestureDetector(
                                                  onTap: () async {
                                                    await _changeColor(
                                                      medIndex,
                                                      entry['value'],
                                                      selectedEmail!,
                                                      user.email,
                                                      takenIndex,
                                                    );
                                                    Provider.of<UserProvider>(
                                                            context,
                                                            listen: false)
                                                        .refreshUser();
                                                  },
                                                  child: MedicineContainer(
                                                    dosage_type:
                                                        med['dosage_type'],
                                                    amt: entry['dosages'],
                                                    color: entry['value'],
                                                    name: med['medicine'],
                                                  ),
                                                );
                                              }).toList(),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (medications.isEmpty) {
                                  return Center(
                                      child: Text("No medication data"));
                                } else {
                                  return Center(
                                      child: Text(
                                          "Please wait for user to allow request"));
                                }
                              },
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                  ],
                );
              }
            }),
      ),
    );
  }
}

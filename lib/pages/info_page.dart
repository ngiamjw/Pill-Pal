import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing_pill_pal/classes/user.dart';
import 'package:testing_pill_pal/components/error_display.dart';
import 'package:testing_pill_pal/components/medication_box.dart';
import 'package:testing_pill_pal/pages/home_page.dart';
import 'package:testing_pill_pal/pages/page_view.dart';
import 'package:testing_pill_pal/providers/user_provider.dart';
import 'package:testing_pill_pal/services/firebase.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class InfoPage extends StatefulWidget {
  InfoPage({super.key});

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  bool isloading = false;
  List<Map<String, dynamic>> medications = [
    {
      'medicine': '',
      'taken': [
        {'value': false, 'date': DateTime.now(), 'dosages': null, 'time': null}
      ],
      'dosage_type': ''
    }
  ];

  final FirestoreService firestoreService = FirestoreService();

  Future<void> fetchAndSetRoutes(List<Map<String, dynamic>> medications) async {
    for (var med in medications) {
      final medicineName = med['medicine'];
      if (medicineName != null && medicineName.isNotEmpty) {
        final route = await fetchRouteFromOpenFDA(medicineName);
        med['dosage_type'] = route; // Set the route in the medication object
      } else {
        med['dosage_type'] = 'ORAL'; // Fallback if no medicine name
      }
    }
  }

  Future<String> fetchRouteFromOpenFDA(String medicineName) async {
    final url = Uri.parse(
        'https://api.fda.gov/drug/label.json?search=openfda.brand_name:"$medicineName"&limit=1');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final results = data['results'] as List<dynamic>;
      if (results.isNotEmpty) {
        String route_type = results[0]['openfda']['route'][0];
        return route_type;
      }
      return 'ORAL';
    } else {
      print('Failed to fetch route for $medicineName');
      return 'ORAL';
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("Medications"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 65, 153, 230),
        automaticallyImplyLeading: !isloading,
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
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: isloading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Text("Please wait a moment while we finish setting up",
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center),
                      SizedBox(
                        height: 25,
                      ),
                      CircularProgressIndicator(),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          // Daily Medication Section Title (only once)
                          if (medications.isNotEmpty)
                            Text("Daily Medication",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),

                          // List of Medication Boxes
                          ...medications.map((med) => MedicationBox(
                                medication: med,
                                onRemove: () {
                                  setState(() {
                                    medications.remove(med);
                                  });
                                },
                              )),

                          // Add new medication box button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                medications.add({
                                  'medicine': '',
                                  'taken': [
                                    {
                                      'value': false,
                                      'date': DateTime.now(),
                                      'dosages': null,
                                      'time': null
                                    }
                                  ],
                                  'dosage_type': ''
                                });
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12.0),
                              margin: const EdgeInsets.only(bottom: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.1), // Subtle shadow
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Center(child: Text("+ Add Medication")),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Submit Button
                    SizedBox(
                      width: double.infinity, // Make the button stretch
                      child: ElevatedButton(
                        onPressed: () async {
                          // Handle the Next button press

                          bool areMedicationsValid = medications.isNotEmpty &&
                              medications.every((med) =>
                                  med['taken'] != null &&
                                  med['medicine'] != '' &&
                                  med['taken'].every((take) =>
                                      take['time'] != null &&
                                      take['dosages'] != null));

                          // Final validation
                          if (areMedicationsValid) {
                            setState(() {
                              isloading = true;
                            });

                            await fetchAndSetRoutes(medications);
                            await firestoreService.updateUser(
                                email: user.email, medications: medications);

                            Provider.of<UserProvider>(context, listen: false)
                                .refreshUser();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SliderPage(currentIndex: 1)),
                            );
                          } else {
                            setState(() {
                              isloading = false;
                            });
                            displayErrorMessage("missing information", context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade300,
                          padding: EdgeInsets.symmetric(
                              vertical: 16), // Adjust the height
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Match the box shape
                          ),
                        ),
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

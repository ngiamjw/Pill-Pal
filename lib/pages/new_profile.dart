import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_pill_pal/classes/user.dart';
import 'package:testing_pill_pal/components/medicine_container.dart';
import 'package:testing_pill_pal/pages/profile.dart';
import 'package:testing_pill_pal/providers/user_provider.dart';

class MedicationPage extends StatefulWidget {
  const MedicationPage({super.key});

  @override
  State<MedicationPage> createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  // Group medications by time

  @override
  Widget build(BuildContext context) {
    // Provider.of<UserProvider>(context, listen: false).refreshUser();
    final User user = Provider.of<UserProvider>(context).getUser;
    // Group medications by time
    Map<String, List<Map<String, dynamic>>> groupMedicationsByTime() {
      Map<String, List<Map<String, dynamic>>> groupedMeds = {
        'Morning': [],
        'Afternoon': [],
        'Evening': [],
        'Night': [],
      };

      for (var med in user.medications) {
        List<dynamic> takenList = med['taken'];

        for (var entry in takenList) {
          if (groupedMeds.containsKey(entry['time'])) {
            groupedMeds[entry['time']]!.add(med);
          }
        }
      }

      return groupedMeds;
    }

    final groupedMeds = groupMedicationsByTime();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 65, 153, 230),
        title: Text('Profile'),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              ListView(
                children: [
                  Column(
                    children: [
                      // Morning Section
                      buildSection('Morning', groupedMeds['Morning']),

                      // Afternoon Section
                      buildSection('Afternoon', groupedMeds['Afternoon']),

                      // Evening Section
                      buildSection('Evening', groupedMeds['Evening']),

                      // Night Section
                      buildSection('Night', groupedMeds['Night']),
                    ],
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width:
                      double.infinity, // Makes the button span the full width
                  child: ElevatedButton(
                    onPressed: () async {
                      // Navigate to the ProfilePage when clicked
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade300,
                      foregroundColor:
                          Theme.of(context).colorScheme.inversePrimary,
                    ),
                    child: Text("Edit Medication"),
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

Widget buildSection(
    String time, List<Map<String, dynamic>>? medicationsForTime) {
  if (medicationsForTime == null || medicationsForTime.isEmpty) {
    return SizedBox
        .shrink(); // Return an empty space if no medication for that time
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          time,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      ListView.builder(
        itemCount: medicationsForTime.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, medIndex) {
          var med = medicationsForTime[medIndex];
          List<dynamic> takenList = med['taken'];

          // Filter entries matching the selected time
          List<Map<String, dynamic>> matchingTaken = takenList
              .where((entry) => entry['time'] == time)
              .toList()
              .cast<Map<String, dynamic>>();

          if (matchingTaken.isEmpty) return SizedBox.shrink();

          return Column(
            children: matchingTaken.map((entry) {
              return MedicineContainer(
                dosage_type: med['dosage_type'],
                amt: entry['dosages'],
                color: entry['value'],
                name: med['medicine'],
              );
            }).toList(),
          );
        },
      ),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:testing_pill_pal/pages/info_page.dart';
import 'package:testing_pill_pal/pages/monitor_email.dart';

class ChoicePage extends StatefulWidget {
  ChoicePage({super.key});

  @override
  _ChoicePageState createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> {
  bool isFirstBoxSelected = false;
  bool isSecondBoxSelected = false;

  void selectBox(int box) {
    setState(() {
      if (box == 1) {
        isFirstBoxSelected = true;
        isSecondBoxSelected = false;
      } else {
        isFirstBoxSelected = false;
        isSecondBoxSelected = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("What are you looking for?"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 65, 153, 230),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 90),

              GestureDetector(
                onTap: () => selectBox(1),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: isFirstBoxSelected
                        ? Theme.of(context).colorScheme.onSecondaryContainer
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.onPrimaryFixed,
                        blurRadius: 4,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height *
                      0.25, // 25% of screen height
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Track Your Medications',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          'Keep track of your prescriptions and never miss a dose',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16), // Space between boxes
              GestureDetector(
                onTap: () => selectBox(2),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: isSecondBoxSelected
                        ? Theme.of(context).colorScheme.onSecondaryContainer
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.onPrimaryFixed,
                        blurRadius: 4,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height *
                      0.25, // 25% of screen height
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Caregiver',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          'Easily track and manage the medications for you and your loved ones',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(), // Push the button to the bottom

              SizedBox(
                width: double.infinity, // Make the button stretch
                child: ElevatedButton(
                  onPressed: () {
                    // Handle the Next button press
                    if (isFirstBoxSelected) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InfoPage()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MonitorEmailPage()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    padding:
                        EdgeInsets.symmetric(vertical: 16), // Adjust the height
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Match the box shape
                    ),
                  ),
                  child: Text(
                    'NEXT',
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

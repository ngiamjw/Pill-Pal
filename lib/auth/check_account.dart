import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing_pill_pal/pages/home_page.dart';
import 'package:testing_pill_pal/pages/opening_screen.dart';
import 'package:testing_pill_pal/pages/page_view.dart';
import 'package:testing_pill_pal/providers/user_provider.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:developer' as developer;
// Import MonitorPage

class CheckAccount extends StatefulWidget {
  String email;
  CheckAccount({super.key, required this.email});

  @override
  State<CheckAccount> createState() => _CheckAccountState();
}

class _CheckAccountState extends State<CheckAccount> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();
    } catch (e) {
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> checkAccountAndNavigate(BuildContext context) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.email)
          .get();
      final data = docSnapshot.data() as Map<String, dynamic>;
      if ((data["medications"] != null && data["medications"].isNotEmpty) ||
          (data['requested_users'] != null &&
              data['requested_users'].isNotEmpty)) {
        // Navigate to HomePage if medicines array is not empty
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SliderPage(
              currentIndex: 1,
            ),
          ),
        );
      } else {
        // Navigate to OpeningScreen if the document does not exist
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OpeningScreen(),
          ),
        );
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    // Use a FutureBuilder to run the account check when the widget builds
    return FutureBuilder<void>(
      future: checkAccountAndNavigate(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            _isLoading == false) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return Container(); // Return an empty container since navigation will handle the transition
      },
    );
  }
}

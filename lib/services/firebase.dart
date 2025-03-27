import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

import 'package:testing_pill_pal/providers/user_provider.dart';

class FirestoreService {
  //get collection of users
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //CREATE: add a new user
  // Future<void> addUser({
  //   required String email,
  //   required List<Map<String, dynamic>> medications,
  // }) {
  //   // Use the email as the document ID
  //   return users.doc(email).set({
  //     'email': email,
  //     'medications': medications,
  //     'permissions': [],
  //     'request': [],
  //     'requested_users': []
  //   });
  // }
  //READ: get user info from database

  Stream<DocumentSnapshot> getUserStream(String email) {
    return users.doc(email).snapshots();
  }

  //UPDATE: update user info given a doc id

  Future<void> updateUser({
    required String email,
    required List<dynamic> medications,
  }) {
    // Use the email as the document ID
    return users.doc(email).update({
      'medications': medications,
    });
  }

  Future<void> updateRequest({
    required String email,
    required String requester_email,
  }) async {
    return users.doc(email).update({
      'request': FieldValue.arrayUnion([requester_email]),
    });
  }

  Future<void> updatePermissions(
      {required String email, required String request_email}) {
    // Use the email as the document ID
    return users.doc(email).update({
      'permissions': FieldValue.arrayUnion([request_email]),
    });
  }

  Future<void> updateRequestedUsers(
      {required String email, required String request_email}) {
    // Use the email as the document ID
    return users.doc(email).update({
      'requested_users': FieldValue.arrayUnion([request_email]),
    });
  }

  Future<void> updateAllMedicationTaken({
    required String email,
    required List<Map<String, dynamic>> medications,
  }) {
    developer.log("update medication run");
    // Use the email as the document ID
    return users.doc(email).update({
      'medications': medications,
    });
  }

  Future<void> resetAllMedicationTaken({
    required String email,
    required List<dynamic> medications,
  }) {
    // Use the email as the document ID
    return users.doc(email).update({
      'medications': medications,
    });
  }

  Future<void> updateMedicationTaken(
      {required String email,
      required int index,
      required bool value,
      required DateTime time,
      required int dose_index}) async {
    // Get the current document
    DocumentSnapshot docSnapshot = await users.doc(email).get();

    if (docSnapshot.exists) {
      // Retrieve the medications array
      List<dynamic> medications = docSnapshot['medications'];

      // Check if the index is valid
      if (index < medications.length &&
          dose_index < medications[index]['taken'].length) {
        // Update the 'taken' field for the specific medication
        medications[index]['taken'][dose_index]['value'] = value;
        medications[index]['taken'][dose_index]['date'] =
            Timestamp.fromDate(time);

        // Write the updated array back to Firestore
        await users.doc(email).update({'medications': medications});
      } else {
        print("Index out of bounds for medications array.");
      }
    } else {
      print("Document does not exist.");
    }
  }

  Future<void> resetMedicationStatus(String email) async {
    DateTime today = DateTime.now();

    DocumentSnapshot docSnapshot = await users.doc(email).get();

    if (docSnapshot.exists) {
      // Retrieve the medications array
      List<dynamic> medications = docSnapshot['medications'];

      for (var medication in medications) {
        List<dynamic> takenList = medication['taken'];

        for (var taken in takenList) {
          Timestamp time = taken['date'];
          DateTime date = time.toDate();

          // Check if the date does not match today's date
          if (date.year != today.year ||
              date.month != today.month ||
              date.day != today.day) {
            if (taken['value'] == true) {
              taken['value'] = false;
            }
          }
        }
      }
      return resetAllMedicationTaken(email: email, medications: medications);
    }
  }

  //DELETE: delete user given a doc id

  Future<void> removeRequest({
    required String email,
    required String requestEmail,
  }) {
    // Use the email as the document ID
    return users.doc(email).update({
      'request': FieldValue.arrayRemove([requestEmail]),
    });
  }
}

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing_pill_pal/classes/user.dart' as Model;
import 'package:testing_pill_pal/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.email).get();

    return Model.User.fromSnap(documentSnapshot);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        Model.User user = Model.User(
          email: email,
          medications: [],
          request: [],
          permissions: [],
          requested_users: [],
        );

        // adding user in our database
        await _firestore.collection("users").doc(email).set(user.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }
}

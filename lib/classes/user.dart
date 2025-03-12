import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final List medications;
  final List permissions;
  final List request;
  final List requested_users;

  User({
    required this.medications,
    required this.permissions,
    required this.email,
    required this.request,
    required this.requested_users,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    User user = User(
        permissions: snapshot['permissions'],
        request: snapshot['request'],
        email: snapshot["email"],
        requested_users: snapshot['requested_users'],
        medications: snapshot['medications']);

    return user;
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "request": request,
        "requested_users": requested_users,
        "medications": medications,
        'permissions': permissions
      };
}

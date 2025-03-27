import 'package:flutter/widgets.dart';
import 'package:testing_pill_pal/auth/auth_methods.dart';
import 'package:testing_pill_pal/classes/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}

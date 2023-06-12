import 'package:bidverse_frontend/models/UserModel.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  UserModel? user;

  setUser(UserModel user) {
    this.user = user;
    notifyListeners();
  }

  deleteUser() {
    UserModel? newUser;
    user = newUser;
    notifyListeners();
  }
}

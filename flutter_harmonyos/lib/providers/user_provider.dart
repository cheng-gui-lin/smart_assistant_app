import 'package:flutter/material.dart';
import 'package:flutter_harmonyos/models/user_profile.dart';

class UserProvider extends ChangeNotifier {
  final UserProfile _profile = UserProfile();

  UserProfile get profile => _profile;

  void updateNickname(String nickname) {
    _profile.nickname = nickname;
    notifyListeners();
  }

  void updateAccount(String account) {
    _profile.account = account;
    notifyListeners();
  }

  void updateBio(String bio) {
    _profile.bio = bio;
    notifyListeners();
  }

  void updateAvatar(String? base64) {
    _profile.avatarBase64 = base64;
    notifyListeners();
  }
}

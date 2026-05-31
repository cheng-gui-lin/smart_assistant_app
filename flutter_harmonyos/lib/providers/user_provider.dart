import 'dart:convert';
import 'package:flutter_harmonyos/models/user_profile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  final UserProfile _profile = UserProfile();

  UserProfile get profile => _profile;

  UserProvider() {
    _loadFromHive();
  }

  void _loadFromHive() {
    final box = Hive.box('user_profile');
    final data = box.get('data') as String?;
    if (data != null) {
      final json = jsonDecode(data) as Map<String, dynamic>;
      _profile.nickname = json['nickname'] as String? ?? '同学';
      _profile.account = json['account'] as String? ?? 'student@example.com';
      _profile.bio = json['bio'] as String? ?? '用更好的自己迎接每一天 ✨';
      _profile.avatarBase64 = json['avatarBase64'] as String?;
    }
  }

  void _saveToHive() {
    final box = Hive.box('user_profile');
    box.put('data', jsonEncode(_profile.toJson()));
  }

  void updateNickname(String nickname) {
    _profile.nickname = nickname;
    _saveToHive();
    notifyListeners();
  }

  void updateAccount(String account) {
    _profile.account = account;
    _saveToHive();
    notifyListeners();
  }

  void updateBio(String bio) {
    _profile.bio = bio;
    _saveToHive();
    notifyListeners();
  }

  void updateAvatar(String? base64) {
    _profile.avatarBase64 = base64;
    _saveToHive();
    notifyListeners();
  }
}

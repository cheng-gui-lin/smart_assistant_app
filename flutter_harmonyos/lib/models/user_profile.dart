class UserProfile {
  String nickname;
  String account;
  String bio;
  String? avatarBase64;

  UserProfile({
    this.nickname = '同学',
    this.account = 'student@example.com',
    this.bio = '用更好的自己迎接每一天 ✨',
    this.avatarBase64,
  });
}

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

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'account': account,
        'bio': bio,
        'avatarBase64': avatarBase64,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        nickname: json['nickname'] as String? ?? '同学',
        account: json['account'] as String? ?? 'student@example.com',
        bio: json['bio'] as String? ?? '用更好的自己迎接每一天 ✨',
        avatarBase64: json['avatarBase64'] as String?,
      );
}

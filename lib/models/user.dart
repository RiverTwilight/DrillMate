class User {
  final String id;
  final String email;
  final String? nickname;
  final String? avatarUrl;

  User({
    required this.id,
    required this.email,
    this.nickname,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      nickname: json['nickname'],
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'avatar_url': avatarUrl,
    };
  }
}

class AuthData {
  int id;
  String username;
  String token;

  AuthData({
    required this.username,
    required this.token,
    required this.id,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      username: json['username'],
      token: json['token'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'token': token,
      'id': id,
    };
  }
}

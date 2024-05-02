class User {
  final int id;
  final String username;
  final int? gameCount;
  final double? winRate;

  User({
    required this.id,
    required this.username,
    this.gameCount,
    this.winRate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      gameCount: json['game_count'],
      winRate: json['win_rate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'game_count': gameCount,
      'win_rate': winRate,
    };
  }
}

class UserResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<User> results;

  UserResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results:
          List<User>.from(json['results'].map((game) => User.fromJson(game))),
    );
  }
}

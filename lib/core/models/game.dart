import 'package:tic_tac_toe/core/models/user.dart';

class Game {
  final int id;
  final DateTime created;
  final dynamic board;
  final User? winner;
  final User firstPlayer;
  final User? secondPlayer;
  final String status;

  Game({
    required this.id,
    required this.created,
    required this.board,
    required this.winner,
    required this.firstPlayer,
    required this.secondPlayer,
    required this.status,
  });

  factory Game.fromJson(dynamic json) {
    return Game(
      id: json['id'],
      created: DateTime.parse(json['created']),
      board: json['board'],
      winner: json['winner'] != null ? User.fromJson(json['winner']) : null,
      firstPlayer: User.fromJson(json['first_player']),
      secondPlayer: json['second_player'] != null
          ? User.fromJson(json['second_player'])
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created': created.toIso8601String(),
      'board': board,
      'winner': winner,
      'first_player': firstPlayer.toJson(),
      'second_player': secondPlayer?.toJson(),
      'status': status,
    };
  }
}

class GamesResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Game> results;

  GamesResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory GamesResponse.fromJson(Map<String, dynamic> json) {
    return GamesResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results:
          List<Game>.from(json['results'].map((game) => Game.fromJson(game))),
    );
  }
}

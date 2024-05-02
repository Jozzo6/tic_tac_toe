import 'package:dio/dio.dart';
import 'package:tic_tac_toe/core/dio_client.dart';
import 'package:tic_tac_toe/core/models/game.dart';

class GameRepository {
  final Dio _dio = DioClient().dio;

  Future<GamesResponse> getGames() async {
    final response = await _dio.get(
      '/games/',
      queryParameters: {
        'limit': 20,
      },
    );
    return GamesResponse.fromJson(response.data);
  }

  Future<GamesResponse> loadMore(String next) async {
    final response = await _dio.get(next);
    return GamesResponse.fromJson(response.data);
  }

  Future<Game> getGame(int gameID) async {
    final response = await _dio.get('/games/$gameID/');
    return Game.fromJson(response.data);
  }

  Future<Game> createGame() async {
    final response = await _dio.post('/games/');
    return Game.fromJson(response.data);
  }

  Future<void> joinGame(int gameID) async {
    await _dio.post('/games/$gameID/join/');
  }

  Future<void> makeMove(int gameID, int row, int col) async {
    await _dio.post(
      '/games/$gameID/move/',
      data: {
        'row': row,
        'col': col,
      },
    );
  }
}

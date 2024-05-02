import 'package:flutter/material.dart';
import 'package:tic_tac_toe/core/enums/view_state.dart';
import 'package:tic_tac_toe/core/models/game.dart';
import 'package:tic_tac_toe/core/property.dart';
import 'package:tic_tac_toe/core/repositories/game_repository.dart';

class GamesTabViewModel extends ChangeNotifier {
  final GameRepository _gameRepository = GameRepository();

  late Property<dynamic> filteredGames = Property([], notifyListeners);
  late Property<ViewState> state = Property(ViewState.loading, notifyListeners);
  late Property<ViewState> createGameState = Property(
    ViewState.idle,
    notifyListeners,
  );
  late Property<ViewState> loadMoreState =
      Property(ViewState.idle, notifyListeners);

  late List<Game> _allGames;
  String? next = '';

  void getGames() async {
    try {
      state.value = ViewState.loading;
      GamesResponse res = await _gameRepository.getGames();
      next = res.next;
      _allGames = res.results;
      filteredGames.value = _allGames;
      state.value = ViewState.idle;
    } catch (e) {
      state.value = ViewState.error;
    }
  }

  void createGame() async {
    try {
      createGameState.value = ViewState.loading;
      await _gameRepository.createGame();
      await Future.delayed(const Duration(seconds: 5));
    } catch (e) {
      createGameState.value = ViewState.error;
    } finally {
      createGameState.value = ViewState.idle;
    }
  }

  Future<void> loadMoreGames() async {
    try {
      if (next == null) {
        return;
      }
      loadMoreState.value = ViewState.loading;
      GamesResponse res = await _gameRepository.loadMore(next!);
      next = res.next;
      _allGames.addAll(res.results);
      filteredGames.value = _allGames;
      loadMoreState.value = ViewState.idle;
    } catch (e) {
      loadMoreState.value = ViewState.error;
    }
  }
}

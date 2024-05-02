import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/core/enums/view_state.dart';
import 'package:tic_tac_toe/core/models/game.dart';
import 'package:tic_tac_toe/core/models/user.dart';
import 'package:tic_tac_toe/core/property.dart';
import 'package:tic_tac_toe/core/repositories/game_repository.dart';
import 'package:tic_tac_toe/core/services/auth_service.dart';

class GameViewModel extends ChangeNotifier {
  final GameRepository _gameRepository = GameRepository();
  final AuthService _authService = AuthService();
  late Timer timer;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  late Property<Game> game = Property(
      Game(
        id: 0,
        firstPlayer: User(id: 0, username: ''),
        created: DateTime.now(),
        board: [],
        status: '',
        winner: null,
        secondPlayer: null,
      ),
      notifyListeners);
  late Property<ViewState> initState =
      Property(ViewState.loading, notifyListeners);
  late Property<bool> canJoin = Property(false, notifyListeners);
  late Property<bool> canMakeMove = Property(false, notifyListeners);
  late Property<ViewState> refreshState =
      Property(ViewState.idle, notifyListeners);
  late User currentUser;
  late Property<ViewState> joinGameState =
      Property(ViewState.idle, notifyListeners);
  late Property<User?> playerOnTurn = Property(null, notifyListeners);

  Future<void> init(int gameId) async {
    try {
      initState.value = ViewState.loading;
      currentUser = User(
        id: _authService.authData.value?.id ?? 0,
        username: _authService.authData.value?.username ?? '',
      );
      await getGame(gameId);
      refreshGameData();
      initState.value = ViewState.idle;
    } catch (e) {
      log(e.toString());
      initState.value = ViewState.error;
    }
  }

  Future<void> refreshGameData() async {
    timer = Timer.periodic(
      const Duration(seconds: 5),
      (Timer t) async {
        try {
          refreshState.value = ViewState.loading;
          await getGame(game.value.id);
          print(game.value.status);
          if (game.value.status == 'finished') {
            t.cancel();
            return;
          }
          refreshState.value = ViewState.success;
        } catch (e) {
          refreshState.value = ViewState.error;
        }
      },
    );
  }

  Future<void> getGame(int gameId) async {
    Game res = await _gameRepository.getGame(gameId);
    game.value = res;
    setCanJoin();
    setTurn();
  }

  void setCanJoin() {
    if (currentUser.id != game.value.firstPlayer.id &&
        game.value.secondPlayer == null &&
        game.value.status == 'open') {
      canJoin.value = true;
    } else {
      canJoin.value = false;
    }
  }

  void setTurn() {
    if (game.value.status != 'progress') {
      canMakeMove.value = false;
      playerOnTurn.value = null;
      return;
    }

    int movesMade =
        game.value.board.expand((i) => i).where((item) => item != null).length;

    if (movesMade == 9) {
      canMakeMove.value = false;
      playerOnTurn.value = null;
      return;
    }

    if (movesMade % 2 == 0) {
      canMakeMove.value = currentUser.id == game.value.firstPlayer.id;
      playerOnTurn.value = game.value.firstPlayer;
    } else {
      canMakeMove.value = currentUser.id == game.value.secondPlayer?.id;
      playerOnTurn.value = game.value.secondPlayer;
    }
  }

  Future<void> makeMove(int row, int col) async {
    try {
      List<List<int?>> board = game.value.board;
      if (game.value.status != 'progress' ||
          !canMakeMove.value ||
          board[row][col] != null) {
        return;
      }
      await _gameRepository.makeMove(game.value.id, row, col);
      await getGame(game.value.id);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> joinGame() async {
    try {
      joinGameState.value = ViewState.loading;
      await _gameRepository.joinGame(game.value.id);
      await getGame(game.value.id);
      joinGameState.value = ViewState.success;
    } catch (e) {
      log(e.toString());
      joinGameState.value = ViewState.error;
    }
  }
}

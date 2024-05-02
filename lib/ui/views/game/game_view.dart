import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/core/enums/view_state.dart';
import 'package:tic_tac_toe/core/models/game.dart';
import 'package:tic_tac_toe/ui/views/game/game_view_model.dart';
import 'package:tic_tac_toe/ui/views/games_tab/games_tab_view_model.dart';

class GameView extends StatefulWidget {
  final Game game;
  const GameView({super.key, required this.game});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  final GameViewModel _viewModel = GameViewModel();

  @override
  void initState() {
    _viewModel.init(widget.game.id);
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        body: body(),
      ),
    );
  }

  Widget body() {
    return Consumer<GameViewModel>(builder: (context, value, _) {
      if (value.initState.value == ViewState.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (value.initState.value == ViewState.error) {
        return const Center(child: Text('Error'));
      } else {
        return Column(
          children: [gameBoard(), gameInfo()],
        );
      }
    });
  }

  Widget gameBoard() {
    return Consumer<GameViewModel>(
      builder: (context, value, _) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              int row = index ~/ 3;
              int col = index % 3;

              return GestureDetector(
                onTap: () {
                  _viewModel.makeMove(row, col);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: Center(
                    child: value.game.value.board.isEmpty
                        ? const SizedBox()
                        : value.game.value.board[row][col] == null
                            ? const SizedBox()
                            : value.game.value.board[row][col] ==
                                    value.game.value.firstPlayer.id
                                ? const Icon(Icons.close)
                                : const Icon(Icons.circle_outlined),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget gameInfo() {
    return Consumer<GameViewModel>(builder: (context, value, _) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (value.playerOnTurn.value != null)
              Text(
                'On turn: ${value.playerOnTurn.value?.username}',
                textScaler: const TextScaler.linear(1.3),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Icon(
                      Icons.close,
                      size: 30,
                    ),
                    Text(value.game.value.firstPlayer.username),
                  ],
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.circle_outlined,
                      size: 30,
                    ),
                    if (value.game.value.secondPlayer != null)
                      Text(value.game.value.secondPlayer!.username)
                    else
                      const Text('Waiting for a player..'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (value.canJoin.value)
              ElevatedButton(
                onPressed: () {
                  _viewModel.joinGame();
                },
                child: const Text('Join'),
              ),
            if (value.game.value.winner != null)
              Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.emoji_events_outlined,
                        size: 30,
                      ),
                      Text(
                        'Winner',
                        textScaler: TextScaler.linear(1.3),
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Text(
                    value.game.value.winner!.username,
                    textScaler: const TextScaler.linear(1.3),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            if (value.game.value.status == 'finished' &&
                value.game.value.winner == null)
              const Text(
                'Draw!',
                textScaler: TextScaler.linear(1.3),
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
          ],
        ),
      );
    });
  }

  Widget errorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('An error occurred'),
          ElevatedButton(
            onPressed: () {
              _viewModel.init(widget.game.id);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

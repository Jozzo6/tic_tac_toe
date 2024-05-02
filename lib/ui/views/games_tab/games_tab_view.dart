import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/core/enums/view_state.dart';
import 'package:tic_tac_toe/core/models/game.dart';
import 'package:tic_tac_toe/core/models/user.dart';
import 'package:tic_tac_toe/ui/views/games_tab/games_tab_view_model.dart';

class GamesTabView extends StatefulWidget {
  const GamesTabView({super.key});

  @override
  State<GamesTabView> createState() => _GamesTabViewState();
}

class _GamesTabViewState extends State<GamesTabView> {
  final GamesTabViewModel _viewModel = GamesTabViewModel();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _viewModel.getGames();
    scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreGames() async {
    await _viewModel.loadMoreGames();
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      _loadMoreGames();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GamesTabViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _viewModel.createGame();
          },
          child: const Icon(Icons.add),
        ),
        body: body(),
      ),
    );
  }

  Widget createGameButton() {
    return Consumer<GamesTabViewModel>(
      builder: (context, value, child) => FloatingActionButton(
        onPressed: _viewModel.createGame,
        child: value.createGameState.value == ViewState.loading
            ? SpinKitCircle()
            : const Icon(Icons.add),
      ),
    );
  }

  Widget body() {
    return Consumer<GamesTabViewModel>(
      builder: (context, value, _) {
        if (value.state.value == ViewState.idle) {
          return content();
        } else if (value.state.value == ViewState.error) {
          return errorWidget();
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget content() {
    return Consumer<GamesTabViewModel>(
      builder: (context, value, _) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              ...value.filteredGames.value
                  .map<Widget>((game) => gameListItem(game))
                  .toList(),
              if (value.loadMoreState.value == ViewState.loading)
                Column(
                  children: [
                    SpinKitCircle(color: Theme.of(context).colorScheme.primary),
                    const Text('Loading more games...')
                  ],
                )
            ],
          ),
        );
      },
    );
  }

  Widget gameListItem(Game game) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Icon(Icons.close),
                    Text(game.firstPlayer.username),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.circle_outlined),
                    if (game.secondPlayer is User)
                      Text(game.secondPlayer!.username)
                    else
                      const Text('Empty slot'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  game.status,
                  textScaler: const TextScaler.linear(1.3),
                ),
                if (game.secondPlayer == null)
                  TextButton(
                    onPressed: () => print('Join'),
                    child: const Text('Join'),
                  ),
                if (game.winner is User)
                  Row(
                    children: [
                      const Icon(Icons.emoji_events_outlined),
                      Text(
                        game.winner!.username,
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget errorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('An error occurred'),
          ElevatedButton(
            onPressed: () {
              _viewModel.getGames();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

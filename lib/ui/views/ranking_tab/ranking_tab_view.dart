import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/core/enums/view_state.dart';
import 'package:tic_tac_toe/core/models/user.dart';
import 'package:tic_tac_toe/ui/views/ranking_tab/ranking_tab_view_model.dart';

class RankingTabView extends StatefulWidget {
  const RankingTabView({super.key});

  @override
  State<RankingTabView> createState() => _RankingTabViewState();
}

class _RankingTabViewState extends State<RankingTabView> {
  final RankingTabViewModel _viewModel = RankingTabViewModel();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _viewModel.getUsers();
    scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreUsers() async {
    try {
      await _viewModel.loadMoreUsers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red[300],
        ),
      );
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      _loadMoreUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RankingTabViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        body: Consumer<RankingTabViewModel>(
          builder: (context, value, _) {
            if (value.state.value == ViewState.idle) {
              return content();
            } else if (value.state.value == ViewState.error) {
              return errorWidget();
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget content() {
    return Consumer<RankingTabViewModel>(
      builder: (context, value, _) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              ...value.users.value.map<Widget>((user) => userListItem(user)),
              if (value.loadMoreState.value == ViewState.loading)
                Column(
                  children: [
                    SpinKitCircle(color: Theme.of(context).colorScheme.primary),
                    const Text('Loading more users...')
                  ],
                ),
              if (value.next == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'No more rankings to load',
                    textScaler: TextScaler.linear(1.3),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget userListItem(User user) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.person,
                  size: 35,
                ),
                Text(user.username),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.emoji_events_outlined),
                    Text(user.winRate!.toStringAsFixed(2)),
                  ],
                ),
                Row(
                  children: [
                    const Text('Games played: '),
                    Text(user.gameCount.toString()),
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
              _viewModel.getUsers();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

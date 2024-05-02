import 'package:flutter/material.dart';
import 'package:tic_tac_toe/core/services/auth_service.dart';
import 'package:tic_tac_toe/ui/views/games_tab/games_tab_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AuthService _authService = AuthService();
  int _currentIndex = 0;

  static const List<Widget> _tabs = [
    GamesTabView(),
    Center(child: Text('Tab 2')),
  ];

  void logout() async {
    try {
      await _authService.logout();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Center(
          child: TextButton(
            onPressed: () async {
              _authService.logout();
            },
            child: const Text('Logout'),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Ranking',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _tabs[_currentIndex],
    );
  }
}

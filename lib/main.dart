import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/app_router.dart';
import 'package:tic_tac_toe/core/services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final AppRouter _appRouter = AppRouter();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    _authService.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _authService,
      child: MaterialApp(
        title: 'TicTacToe',
        onGenerateRoute: _appRouter.onGenerateRoute,
        navigatorKey: _navigatorKey,
        initialRoute: '/',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}

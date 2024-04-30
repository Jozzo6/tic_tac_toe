import 'package:flutter/cupertino.dart';
import 'package:tic_tac_toe/ui/views/home_view.dart';
import 'package:tic_tac_toe/ui/views/loading_view.dart';
import 'package:tic_tac_toe/ui/views/login/login_view.dart';
import 'package:tic_tac_toe/ui/views/register/register_view.dart';

class AppRouter {
  static const String loading = '/loading';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  Route onGenerateRoute(RouteSettings routeSettings) {
    late Widget page;
    final String route = routeSettings.name ?? '';

    if (route == loading || route == '/') {
      page = const LoadingView();
    } else if (route == login) {
      page = const LoginView();
    } else if (route == register) {
      page = const RegisterView();
    } else if (route == home) {
      page = HomeView();
    } else {
      throw Exception('Unknown route: $route');
    }

    return CupertinoPageRoute(builder: (_) => page, settings: routeSettings);
  }
}

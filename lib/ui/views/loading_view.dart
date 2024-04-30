import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/core/enums/auth_state.dart';
import 'package:tic_tac_toe/core/services/auth_service.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authValue, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (authValue.state.value == AuthState.authenticated) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (authValue.state.value == AuthState.unauthenticated) {
            Navigator.of(context).pushReplacementNamed('/login');
          }
        });
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

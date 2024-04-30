import 'package:flutter/material.dart';
import 'package:tic_tac_toe/core/enums/auth_state.dart';
import 'package:tic_tac_toe/core/property.dart';
import 'package:tic_tac_toe/core/repositories/auth_repository.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal() {
    state = Property<AuthState>(AuthState.uninitialized, notifyListeners);
  }

  final AuthRepository _authRepository = AuthRepository();
  late Property<AuthState> state;

  void initialize() async {
    // Init
  }

  Future<void> logout() async {
    // Logout

  }

  Future<void> login(String username, password) async {
    // Login
  }

  Future<void> register(String username, password) async {
    // register
  }
}

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/core/enums/view_state.dart';
import 'package:tic_tac_toe/core/property.dart';
import 'package:tic_tac_toe/core/services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _service = AuthService();

  late final state = Property<ViewState>(ViewState.idle, notifyListeners);
  late final username = Property<String>('', notifyListeners);
  late final password = Property<String>('', notifyListeners);

  Future<void> register() async {
    try {
      state.value = ViewState.loading;
      await _service.register(username.value, password.value);
      state.value = ViewState.success;
    } catch (e) {
      throw e.toString();
    } finally {
      state.value = ViewState.idle;
    }
  }
}

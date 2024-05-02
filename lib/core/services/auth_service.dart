import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe/core/dio_client.dart';
import 'package:tic_tac_toe/core/enums/auth_state.dart';
import 'package:tic_tac_toe/core/models/auth_data.dart';
import 'package:tic_tac_toe/core/property.dart';
import 'package:tic_tac_toe/core/repositories/auth_repository.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal() {
    state = Property<AuthState>(AuthState.uninitialized, notifyListeners);
    authData = Property<AuthData?>(null, notifyListeners);
  }

  final AuthRepository _authRepository = AuthRepository();
  final DioClient _dioClient = DioClient();
  late Property<AuthState> state;
  late Property<AuthData?> authData;

  Future<void> initialize() async {
    AuthData? res = await getSavedAuthData();
    if (res == null) {
      state.value = AuthState.unauthenticated;
      return;
    }
    _dioClient.setToken(res.token);
    authData.value = res;
    state.value = AuthState.authenticated;
  }

  Future<AuthData?> getSavedAuthData() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    String? auth = instance.getString('auth');
    if (auth == null) {
      return null;
    }
    return AuthData.fromJson(json.decode(auth));
  }

  Future<void> saveAuthData(authData) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    await instance.setString('auth', json.encode(authData));
  }

  Future<dynamic> logout() async {
    try {
      SharedPreferences instance = await SharedPreferences.getInstance();
      await instance.remove('auth');
      await _authRepository.logout();
      authData.value = null;
      state.value = AuthState.unauthenticated;
    } catch (e) {
      return false;
    }
  }

  Future<void> login(String username, password) async {
    try {
      dynamic res = await _authRepository.login(username, password);
      AuthData authData = AuthData.fromJson(res);

      _dioClient.setToken(authData.token);
      await saveAuthData(authData);
      this.authData.value = authData;
      state.value = AuthState.authenticated;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> register(String username, password) async {
    try {
      dynamic res = await _authRepository.register(username, password);
      AuthData authData = AuthData.fromJson(res);

      _dioClient.setToken(authData.token);
      await saveAuthData(authData);
      this.authData.value = authData;
      state.value = AuthState.authenticated;
    } catch (e) {
      throw e.toString();
    }
  }
}

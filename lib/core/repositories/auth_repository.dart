import 'package:dio/dio.dart';
import 'package:tic_tac_toe/core/dio_client.dart';

class AuthRepository {
  final Dio _dio = DioClient().dio;

  Future<dynamic> login(String username, String password) async {
    try {
      final response = await _dio.post('/login/', data: {
        'username': username,
        'password': password,
      });

      return response.data;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<dynamic> register(String username, String password) async {
    try {
      final response = await _dio.post('/register/', data: {
        'username': username,
        'password': password,
      });

      return response.data;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/logout/');
    } on Exception catch (e) {
      throw e.toString();
    }
  }
}

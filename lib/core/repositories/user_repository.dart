import 'package:dio/dio.dart';
import 'package:tic_tac_toe/core/dio_client.dart';
import 'package:tic_tac_toe/core/models/user.dart';

class UserRepository {
  final Dio _dio = DioClient().dio;

  Future<UserResponse> getUsers() async {
    final response = await _dio.get(
      '/users/',
      queryParameters: {
        'limit': 10,
      },
    );
    return UserResponse.fromJson(response.data);
  }

  Future<UserResponse> loadMore(String next) async {
    final response = await _dio.get(next);
    return UserResponse.fromJson(response.data);
  }

  Future<User> getUser(int id) async {
    final response = await _dio.get('/users/$id/');
    return User.fromJson(response.data);
  }
}

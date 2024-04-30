import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _singleton = DioClient._internal();
  static const String baseUrl = 'https://tictactoe.aboutdream.io';

  late Dio _dio;

  factory DioClient() {
    return _singleton;
  }

  DioClient._internal() {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  Dio get dio => _dio;

  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void removeToken() {
    _dio.options.headers.remove('Authorization');
  }
}

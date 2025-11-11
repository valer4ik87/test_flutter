import 'package:dio/dio.dart';

class DioClient {
  late final Dio dio;

  DioClient._internal() {
    dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: false,
      responseHeader: false,
    ));
  }

  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;
}
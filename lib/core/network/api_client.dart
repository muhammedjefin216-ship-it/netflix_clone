import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;

  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        queryParameters: {
          'api_key': ApiConstants.apiKey,
          'language': ApiConstants.language,
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        responseBody: false,
        requestBody: false,
        error: true,
        logPrint: (o) => print('[API] $o'),
      ),
    );
  }

  static ApiClient get instance {
    _instance ??= ApiClient._();
    return _instance!;
  }

  Dio get dio => _dio;
}

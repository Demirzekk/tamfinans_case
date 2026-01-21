import 'dart:developer';

import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'api_exceptions.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: ApiConstants.connectionTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        responseType: ResponseType.plain,
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        logPrint: (obj) => log('[API] $obj'),
      ),
    );
  }

  Future<String> get(String url) async {
    try {
      final response = await _dio.get<String>(url);

      if (response.statusCode == 200 && response.data != null) {
        return response.data!;
      }

      if (response.statusCode == 404) {
        throw const NotFoundException();
      }

      throw ServerException(
        statusCode: response.statusCode ?? 500,
        originalError: null,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<String> getExchangeRates(DateTime date) async {
    final url = ApiConstants.getExchangeRateUrl(date);
    return get(url);
  }

  ApiException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(originalError: error);

      case DioExceptionType.connectionError:
        return NetworkException(originalError: error);

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 404) {
          return const NotFoundException();
        }
        if (statusCode != null && statusCode >= 500) {
          return ServerException(statusCode: statusCode, originalError: error);
        }
        return ClientException(statusCode: statusCode, originalError: error);

      case DioExceptionType.cancel:
        return const ClientException(message: 'İstek iptal edildi');

      default:
        return NetworkException(originalError: error);
    }
  }
}

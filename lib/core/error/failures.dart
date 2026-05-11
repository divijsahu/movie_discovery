import 'package:dio/dio.dart';

sealed class AppFailure {
  final String message;
  const AppFailure(this.message);

  factory AppFailure.fromDio(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const NetworkFailure();
    }
    if (e.response?.statusCode == 401) {
      // Extract the actual API error message if available (e.g. TMDB invalid key)
      final apiMessage = e.response?.data?['status_message'] ??
          e.response?.data?['message'] ??
          e.response?.data?['error'];
      return UnauthorizedFailure(apiMessage?.toString());
    }
    return ServerFailure(
      e.response?.data?['message']?.toString() ?? e.message ?? 'Server error',
      statusCode: e.response?.statusCode,
    );
  }
}

class ServerFailure extends AppFailure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
}

class NetworkFailure extends AppFailure {
  const NetworkFailure() : super('No internet connection');
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}

class CacheFailure extends AppFailure {
  const CacheFailure(super.message);
}

class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure([String? message])
      : super(message ?? 'Invalid API key or unauthorized.');
}

import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final List<Duration> retryDelays;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 3),
      Duration(seconds: 6),
    ],
  });

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final attempt = err.requestOptions.extra['retryAttempt'] as int? ?? 0;

    if (!_isRetryable(err) || attempt >= maxRetries) {
      handler.next(err);
      return;
    }

    await Future.delayed(
      attempt < retryDelays.length ? retryDelays[attempt] : retryDelays.last,
    );

    err.requestOptions.extra['retryAttempt'] = attempt + 1;

    try {
      final response = await dio.fetch(err.requestOptions);
      handler.resolve(response);
    } catch (_) {
      handler.next(err);
    }
  }

  bool _isRetryable(DioException err) =>
      err.type == DioExceptionType.connectionTimeout ||
      err.type == DioExceptionType.receiveTimeout ||
      err.type == DioExceptionType.connectionError ||
      (err.response?.statusCode != null && err.response!.statusCode! >= 500);
}

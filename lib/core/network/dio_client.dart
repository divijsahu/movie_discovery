import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/core/network/api_constants.dart';
import 'package:movie_discovery/core/network/interceptors/auth_interceptor.dart';
import 'package:movie_discovery/core/network/interceptors/retry_interceptor.dart';

final reqresDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.reqresBase,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));
  dio.interceptors.addAll([
    ReqresAuthInterceptor(),
    RetryInterceptor(dio: Dio(BaseOptions(baseUrl: ApiConstants.reqresBase))),
    if (kDebugMode) LogInterceptor(responseBody: true),
  ]);
  return dio;
});

final tmdbDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.tmdbBase,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    queryParameters: {'api_key': ApiConstants.tmdbApiKey},
  ));
  dio.interceptors.addAll([
    RetryInterceptor(dio: Dio(BaseOptions(baseUrl: ApiConstants.tmdbBase))),
    if (kDebugMode) LogInterceptor(responseBody: true),
  ]);
  return dio;
});

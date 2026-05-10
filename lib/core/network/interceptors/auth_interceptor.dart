import 'package:dio/dio.dart';
import 'package:movie_discovery/core/network/api_constants.dart';

class ReqresAuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['x-api-key'] = ApiConstants.reqresApiKey;
    handler.next(options);
  }
}

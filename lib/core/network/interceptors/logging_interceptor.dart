import 'package:dio/dio.dart';
// ignore_for_file: avoid_print

class AppLogInterceptor extends Interceptor {
  final _stopwatches = <String, Stopwatch>{};

  String _key(RequestOptions o) => '${o.method}:${o.uri}:${o.hashCode}';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _stopwatches[_key(options)] = Stopwatch()..start();
    final attempt = options.extra['retryAttempt'] as int? ?? 0;
    final tag = attempt > 0 ? ' [retry #$attempt]' : '';
    print('┌─ 🌐 ${options.method}$tag → ${_shortUri(options.uri)}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final options = response.requestOptions;
    final elapsed = _elapsed(options);
    final status = response.statusCode;
    final summary = _summarise(options.uri, response.data);

    print('└─ ✅ ${options.method} ${_shortUri(options.uri)} → $status  ($elapsed)');
    if (summary != null) print('   $summary');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    final elapsed = _elapsed(options);
    final attempt = options.extra['retryAttempt'] as int? ?? 0;
    final status = err.response?.statusCode;

    if (attempt > 0) {
      print('├─ 🔁 RETRY #$attempt ${options.method} ${_shortUri(options.uri)}');
    }

    final statusStr = status != null ? '$status ' : '';
    print('└─ ❌ ${options.method} ${_shortUri(options.uri)} → $statusStr${err.type.name}  ($elapsed)');

    final hint = err.response?.data?['message'] ?? err.response?.data?['error'];
    if (hint != null) print('   hint: $hint');

    handler.next(err);
  }

  // ─── Helpers ──────────────────────────────────────────────

  String _shortUri(Uri uri) {
    final path = uri.path;
    final query = uri.queryParameters.entries
        .where((e) => e.key != 'api_key' && e.key != 'apikey') // hide API keys from logs
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    return query.isEmpty ? path : '$path?$query';
  }

  String _elapsed(RequestOptions options) {
    final sw = _stopwatches.remove(_key(options));
    if (sw == null) return '?ms';
    sw.stop();
    final ms = sw.elapsedMilliseconds;
    return ms >= 1000 ? '${(ms / 1000).toStringAsFixed(1)}s' : '${ms}ms';
  }

  String? _summarise(Uri uri, dynamic data) {
    if (data is! Map) return null;
    final path = uri.path;

    // Reqres users list
    if (path.contains('/users') && data['data'] is List) {
      final list = data['data'] as List;
      final page = data['page'];
      final total = data['total_pages'];
      return '   📋 ${list.length} users  (page $page of $total)';
    }

    // Reqres create user
    if (path.contains('/users') && data['id'] != null) {
      return '   👤 created user id=${data['id']} name=${data['name']}';
    }

    // TMDB trending
    if (path.contains('/trending')) {
      final results = data['results'];
      if (results is List) {
        final page = data['page'];
        final total = data['total_pages'];
        return '   🎬 ${results.length} movies  (page $page of $total)';
      }
    }

    // TMDB movie detail
    if (RegExp(r'/movie/\d+$').hasMatch(path)) {
      final title = data['title'];
      final year = (data['release_date'] as String?)?.substring(0, 4);
      return '   🎥 $title ($year)';
    }

    return null;
  }
}

abstract class AppConstants {
  static const String APP_NAME = 'Flutter App Template';
  static const String APP_VERSION = '1.0.0';
  static const bool IS_DEBUG = true;
  
  static const String ERROR_MESSAGE = 'Something went wrong, Please try again later';
  static const String NETWORK_ERROR = 'Network connection failed. Please check your internet.';
  
  static const int DEFAULT_PAGE_SIZE = 20;
  static const int MAX_IMAGE_SIZE = 5 * 1024 * 1024;
  
  AppConstants._();
}

class ApiEndpoints {
  static String _host = 'https://api.yourapp.com';
  
  static void setHost(String url) => _host = url;
  
  static String get HOST => _host.endsWith('/') ? _host.substring(0, _host.length - 1) : _host;
  static String get BASE_URL => '$HOST/api/v1';
  
  static String get AUTH => '$BASE_URL/auth';
  static String get LOGIN => '$AUTH/signin';
  static String get REGISTER => '$AUTH/signup';
  
  static String endpoint(String relativePath) {
    if (relativePath.startsWith('http://') || relativePath.startsWith('https://')) {
      return relativePath;
    }
    final cleanBase = BASE_URL.endsWith('/') ? BASE_URL.substring(0, BASE_URL.length - 1) : BASE_URL;
    final cleanPath = relativePath.startsWith('/') ? relativePath.substring(1) : relativePath;
    return '$cleanBase/$cleanPath';
  }
  
  ApiEndpoints._();
}

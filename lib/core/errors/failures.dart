sealed class AppFailure {
  final String message;
  const AppFailure(this.message);
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
  const UnauthorizedFailure() : super('Session expired. Please log in again.');
}

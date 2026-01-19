import 'package:equatable/equatable.dart';

/// Base failure class for Dartz Either error handling
/// All failures extend this class and provide a descriptive message
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Server-related failures (API errors, network issues)
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred'])
      : super(message);
}

/// Cache-related failures (local storage issues)
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred'])
      : super(message);
}

/// Location-related failures (GPS, permissions)
class LocationFailure extends Failure {
  const LocationFailure(String message) : super(message);
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure([String message = 'Authentication failed'])
      : super(message);
}

/// Validation failures (invalid input)
class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

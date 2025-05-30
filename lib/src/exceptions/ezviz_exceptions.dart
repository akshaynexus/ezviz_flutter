/// Base exception for all EZVIZ API errors.
class EzvizException implements Exception {
  final String message;
  final String? code;

  EzvizException(this.message, {this.code});

  @override
  String toString() => 'EzvizException: $message (code: $code)';
}

/// Exception for authentication failures.
class EzvizAuthException extends EzvizException {
  EzvizAuthException(super.message, {super.code});
}

/// Exception for API errors.
class EzvizApiException extends EzvizException {
  EzvizApiException(super.message, {super.code});
}

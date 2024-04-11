enum StatusCode {
  noData,
  socketException,
  unauthorized, // 401
  dioException,
  unknownError,
}

class AppException implements Exception {
  AppException({
    required this.message,
    required this.statusCode,
    required this.identifier,
  });

  final String message;
  final StatusCode statusCode;
  final String identifier;

  @override
  String toString() {
    return 'statusCode=${statusCode.name}\nmessage=$message\nidentifier=$identifier';
  }
}

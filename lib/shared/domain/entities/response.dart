class NetworkResponse {
  NetworkResponse({
    required this.statusCode,
    this.statusMessage,
    this.data = const {},
  });

  final int statusCode;
  final String? statusMessage;
  final dynamic data;

  @override
  String toString() {
    return 'statusCode=$statusCode\nstatusMessage=$statusMessage\n data=$data';
  }
}

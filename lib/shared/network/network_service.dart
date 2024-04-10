import 'package:ventrata_challenge/shared/domain/entities/response.dart';
import 'package:ventrata_challenge/shared/domain/entities/result.dart';
import 'package:ventrata_challenge/shared/exceptions/app_exception.dart';

abstract class NetworkService {
  String get baseUrl;

  Map<String, Object> get headers;

  Future<Result<NetworkResponse, AppException>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, Object>? extraHeaders,
  });

  Future<Result<NetworkResponse, AppException>> post(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  });
}

import 'package:basic_flutter_helper/basic_flutter_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:ventrata_challenge/config/app_config.dart';
import 'package:ventrata_challenge/shared/domain/entities/response.dart';
import 'package:ventrata_challenge/shared/domain/entities/result.dart';
import 'package:ventrata_challenge/shared/exceptions/app_exception.dart';
import 'package:ventrata_challenge/shared/mixins/exception_handler_mixin.dart';
import 'package:ventrata_challenge/shared/network/network_service.dart';

@LazySingleton(as: NetworkService)
class DioNetworkService extends NetworkService with ExceptionHandlerMixin {
  final Dio dio;

  DioNetworkService(this.dio) {
    dio.options = BaseOptions(
      baseUrl: baseUrl,
      headers: headers,
    );
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (object) {
            printLog(object.toString());
          },
        ),
      );
    }
  }

  @override
  String get baseUrl => AppConfig.baseUrl;

  @override
  Map<String, Object> get headers =>
      {
        'accept': 'application/json',
        'content-type': 'application/json',
      };

  @override
  Future<Result<NetworkResponse, AppException>> get(String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, Object>? extraHeaders,
  }) {
    final updatedHeaders = Map<String, Object>.from(headers);
    if (extraHeaders != null) {
      updatedHeaders.addAll(extraHeaders);
    }
    final res = handleException(
          () =>
          dio.get(
            endpoint,
            queryParameters: queryParameters,
            options: Options(
              headers: updatedHeaders,
            ),
          ),
      endpoint: endpoint,
    );
    return res;
  }

  @override
  Future<Result<NetworkResponse, AppException>> post(String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) {
    final res = handleException(
          () =>
          dio.post(
            endpoint,
            queryParameters: queryParameters,
            data: data,
            options: Options(
              headers: headers,
            ),
          ),
      endpoint: endpoint,
    );
    return res;
  }
}

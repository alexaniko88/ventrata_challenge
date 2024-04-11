import 'dart:io';

import 'package:basic_flutter_helper/basic_flutter_helper.dart';
import 'package:dio/dio.dart';
import 'package:ventrata_challenge/shared/domain/entities/response.dart';
import 'package:ventrata_challenge/shared/domain/entities/result.dart';
import 'package:ventrata_challenge/shared/exceptions/app_exception.dart';
import 'package:ventrata_challenge/shared/network/network_service.dart';

mixin ExceptionHandlerMixin on NetworkService {
  Future<Result<NetworkResponse, AppException>> handleException<T extends Object>(
    Future<Response<dynamic>> Function() handler, {
    String endpoint = '',
  }) async {
    try {
      final res = await handler();
      return Success(
        NetworkResponse(
          statusCode: res.statusCode ?? 200,
          data: res.data,
          statusMessage: res.statusMessage,
        ),
      );
    } catch (e) {
      String message = '';
      String identifier = '';
      late StatusCode statusCode;
      printLog("$runtimeType:: ${e.runtimeType}");
      if (e is SocketException) {
        message = 'Unable to connect to the server.';
        statusCode = StatusCode.socketException;
        identifier = 'Socket Exception ${e.message}\n at  $endpoint';
      } else if (e is DioException) {
        message = e.response?.data?['message'] ?? 'Internal Error occurred';
        statusCode = e.response?.statusCode == 401 ? StatusCode.unauthorized : StatusCode.dioException;
        identifier = 'DioException ${e.message} \nat  $endpoint';
      } else {
        message = 'Unknown error occurred';
        statusCode = StatusCode.unknownError;
        identifier = 'Unknown error ${e.toString()}\n at $endpoint';
      }
      return Failure(
        AppException(
          message: message,
          statusCode: statusCode,
          identifier: identifier,
        ),
      );
    }
  }
}

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventrata_challenge/data/dtos/login_dto.dart';
import 'package:ventrata_challenge/data/dtos/user_dto.dart';
import 'package:ventrata_challenge/shared/domain/entities/result.dart';
import 'package:ventrata_challenge/shared/exceptions/app_exception.dart';
import 'package:ventrata_challenge/shared/network/network_service.dart';

abstract class UserRemoteDatasource {
  Future<Result<LoginDTO, AppException>> login({
    required String username,
    required String password,
  });

  Future<Result<UserDTO, AppException>> fetchUser({
    required String token,
  });
}

abstract class UserLocalDatasource {
  Future<Result<bool, AppException>> saveToken({
    required String token,
  });

  Future<Result<String, AppException>> getToken();

  Future<Result<bool, AppException>> deleteToken();
}

@LazySingleton(as: UserRemoteDatasource)
class UserRemoteDatasourceImpl extends UserRemoteDatasource {
  UserRemoteDatasourceImpl(this.networkService);

  final NetworkService networkService;

  @override
  Future<Result<LoginDTO, AppException>> login({
    required String username,
    required String password,
  }) async {
    try {
      final result = await networkService.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
          'expiresInMins': 1,
        },
      );
      return result.fold(
        (response) => Result.success(LoginDTO.fromJson(response.data)),
        (exception) => Result.failure(exception),
      );
    } on Exception catch (e) {
      return Result.failure(
        AppException(
          identifier: 'login',
          statusCode: StatusCode.dioException,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Result<UserDTO, AppException>> fetchUser({required String token}) async {
    try {
      final result = await networkService.get(
        '/auth/me',
        extraHeaders: {
          'Authorization': 'Bearer $token',
        },
      );
      return result.fold(
        (response) => Result.success(UserDTO.fromJson(response.data)),
        (exception) => Result.failure(exception),
      );
    } on Exception catch (e) {
      return Result.failure(
        AppException(
          identifier: 'refreshUser',
          statusCode: StatusCode.dioException,
          message: e.toString(),
        ),
      );
    }
  }
}

@LazySingleton(as: UserLocalDatasource)
class UserLocalDatasourceImpl extends UserLocalDatasource {
  UserLocalDatasourceImpl();

  @override
  Future<Result<String, AppException>> getToken() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');
      if (token != null) {
        return Result.success(token);
      } else {
        return Result.failure(
          AppException(
            identifier: 'getToken',
            statusCode: StatusCode.noData,
            message: 'No token found',
          ),
        );
      }
    } catch (e) {
      return Result.failure(
        AppException(
          identifier: 'getToken',
          statusCode: StatusCode.unknownError,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Result<bool, AppException>> saveToken({required String token}) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final result = await sharedPreferences.setString('token', token);
      return Result.success(result);
    } catch (e) {
      return Result.failure(
        AppException(
          identifier: 'saveToken',
          statusCode: StatusCode.unknownError,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Result<bool, AppException>> deleteToken() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final result = await sharedPreferences.remove('token');
      return Result.success(result);
    } catch (e) {
      return Result.failure(
        AppException(
          identifier: 'deleteToken',
          statusCode: StatusCode.unknownError,
          message: e.toString(),
        ),
      );
    }
  }
}

import 'package:injectable/injectable.dart';
import 'package:ventrata_challenge/domain/login/entities/login_model.dart';
import 'package:ventrata_challenge/domain/user/entities/user_model.dart';
import 'package:ventrata_challenge/domain/user/repositories/user_repository.dart';
import 'package:ventrata_challenge/shared/domain/entities/result.dart';
import 'package:ventrata_challenge/shared/exceptions/app_exception.dart';
import 'package:ventrata_challenge/shared/network/network_service.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final NetworkService networkService;

  UserRepositoryImpl({required this.networkService});

  @override
  Future<Result<LoginModel, AppException>> login({
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
        (response) => Result.success(LoginModel.fromJson(response.data)),
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
  Future<Result<UserModel, AppException>> refreshUser({required String token}) async {
    try {
      final result = await networkService.get(
        '/auth/me',
        extraHeaders: {
          'Authorization': 'Bearer $token',
        },
      );
      return result.fold(
        (response) => Result.success(UserModel.fromJson(response.data)),
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
}

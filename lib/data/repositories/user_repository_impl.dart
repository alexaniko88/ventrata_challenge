import 'package:injectable/injectable.dart';
import 'package:ventrata_challenge/data/data_mappers.dart';
import 'package:ventrata_challenge/data/datasources/user_datasource.dart';
import 'package:ventrata_challenge/domain/login/entities/login_model.dart';
import 'package:ventrata_challenge/domain/user/entities/user_model.dart';
import 'package:ventrata_challenge/domain/user/repositories/user_repository.dart';
import 'package:ventrata_challenge/shared/domain/entities/result.dart';
import 'package:ventrata_challenge/shared/exceptions/app_exception.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  final UserRemoteDatasource remoteDatasource;
  final UserLocalDatasource localDatasource;

  @override
  Future<Result<LoginModel, AppException>> login({
    required String username,
    required String password,
  }) async {
    final result = await remoteDatasource.login(
      username: username,
      password: password,
    );
    return result.fold(
      (response) => Result.success(response.toModel()),
      (exception) => Result.failure(exception),
    );
  }

  @override
  Future<Result<UserModel, AppException>> fetchUser({required String token}) async {
    final result = await remoteDatasource.fetchUser(
      token: token,
    );
    return result.fold(
      (response) => Result.success(response.toModel()),
      (exception) => Result.failure(exception),
    );
  }

  @override
  Future<Result<String, AppException>> getToken() async {
    final result = await localDatasource.getToken();
    return result.fold(
      (response) => Result.success(response),
      (exception) => Result.failure(exception),
    );
  }

  @override
  Future<Result<bool, AppException>> saveToken({required String token}) async {
    final result = await localDatasource.saveToken(
      token: token,
    );
    return result.fold(
      (response) => Result.success(response),
      (exception) => Result.failure(exception),
    );
  }
}

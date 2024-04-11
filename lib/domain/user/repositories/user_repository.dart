import 'package:ventrata_challenge/domain/login/entities/login_model.dart';
import 'package:ventrata_challenge/domain/user/entities/user_model.dart';
import 'package:ventrata_challenge/shared/domain/entities/result.dart';
import 'package:ventrata_challenge/shared/exceptions/app_exception.dart';

abstract class UserRepository {
  Future<Result<LoginModel, AppException>> login({
    required String username,
    required String password,
  });

  Future<Result<UserModel, AppException>> fetchUser({
    required String token,
  });

  Future<Result<bool, AppException>> saveToken({
    required String token,
  });

  Future<Result<String, AppException>> getToken();
}

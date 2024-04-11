import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ventrata_challenge/domain/login/cubits/login_state.dart';
import 'package:ventrata_challenge/domain/user/repositories/user_repository.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.repository) : super(const LoginState(status: LoginStatus.initial));

  final UserRepository repository;

  Future<void> tryAutoLogin() async {
    emit(const LoginState(status: LoginStatus.loading));
    final tokenResult = await repository.getToken();
    tokenResult.fold(
      (token) async {
        final userResult = await repository.fetchUser(token: token);
        userResult.fold(
          (user) => emit(const LoginState(status: LoginStatus.success)),
          (exception) => emit(const LoginState(status: LoginStatus.initial)),
        );
      },
      (exception) => emit(const LoginState(status: LoginStatus.initial)),
    );
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(state.copyWith(status: LoginStatus.loading));
    final result = await repository.login(
      username: username,
      password: password,
    );
    result.fold(
      (loginModel) async {
        final token = loginModel.token;
        final tokenResult = await repository.saveToken(token: token);
        tokenResult.fold(
          (response) => emit(const LoginState(status: LoginStatus.success)),
          (exception) => emit(
            LoginState(
              status: LoginStatus.failure,
              exception: exception,
            ),
          ),
        );
      },
      (exception) => emit(
        LoginState(
          status: LoginStatus.failure,
          exception: exception,
        ),
      ),
    );
  }
}

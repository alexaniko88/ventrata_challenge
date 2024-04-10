import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ventrata_challenge/domain/login/cubits/login_state.dart';
import 'package:ventrata_challenge/domain/user/repositories/user_repository.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.repository) : super(const LoginState(status: LoginStatus.initial));

  final UserRepository repository;

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
      (loginModel) => emit(
        LoginState(
          status: LoginStatus.success,
          loginModel: loginModel,
        ),
      ),
      (exception) => emit(
        LoginState(
          status: LoginStatus.failure,
          exception: exception,
        ),
      ),
    );
  }
}

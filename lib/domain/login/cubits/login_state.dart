import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    required LoginStatus status,
    Exception? exception,
  }) = _LoginState;
}

enum LoginStatus {
  initial,
  loading,
  success,
  logout,
  failure,
}

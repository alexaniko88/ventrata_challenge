import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ventrata_challenge/domain/login/entities/login_model.dart';

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
  failure,
}
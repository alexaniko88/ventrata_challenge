import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ventrata_challenge/domain/user/entities/user_model.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    required ProfileStatus status,
    UserModel? userModel,
    Exception? exception,
  }) = _ProfileState;
}

enum ProfileStatus {
  initial,
  success,
  failure,
  unauthorized,
}

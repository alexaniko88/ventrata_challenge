import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_dto.freezed.dart';

part 'login_dto.g.dart';

@freezed
class LoginDTO with _$LoginDTO {
  const factory LoginDTO({
    required int id,
    required String token,
    required String? username,
    required String? email,
    required String? firstName,
    required String? lastName,
    required String? gender,
    required String? image,
  }) = _LoginDTO;

  factory LoginDTO.fromJson(Map<String, dynamic> json) => _$LoginDTOFromJson(json);
}

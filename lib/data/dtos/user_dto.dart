import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

//ignore_for_file: invalid_annotation_target
@freezed
class UserDTO with _$UserDTO {
  @JsonSerializable(explicitToJson: true)

  const UserDTO._();

  const factory UserDTO({
    required int id,
    required String? username,
    required String? email,
    required String? firstName,
    required String? lastName,
    required String? gender,
    required String? image,
  }) = _UserDTO;

  factory UserDTO.fromJson(Map<String, dynamic> json) => _$UserDTOFromJson(json);
}
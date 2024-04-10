import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_model.freezed.dart';
part 'login_model.g.dart';

//ignore_for_file: invalid_annotation_target
@freezed
class LoginModel with _$LoginModel {
  @JsonSerializable(explicitToJson: true)

  const LoginModel._();

  const factory LoginModel({
    required int id,
    required String token,
  }) = _LoginModel;

  factory LoginModel.fromJson(Map<String, dynamic> json) => _$LoginModelFromJson(json);
}
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';

part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required int id,
    required String title,
    required String description,
    required double price,
    required String brand,
    required String? thumbnail,
    @Default(1) int refreshed,
    @Default(0) int amount,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
}
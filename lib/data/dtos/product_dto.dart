import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_dto.freezed.dart';

part 'product_dto.g.dart';

@freezed
class ProductDTO with _$ProductDTO {
  const factory ProductDTO({
    required int id,
    required String? title,
    required String? description,
    required double price,
    required double discountPercentage,
    required double rating,
    required int stock,
    required String? brand,
    required String? category,
    required String? thumbnail,
    required List<String> images,
  }) = _ProductDTO;

  factory ProductDTO.fromJson(Map<String, dynamic> json) => _$ProductDTOFromJson(json);
}

@freezed
class ProductsDTO with _$ProductsDTO {
  const factory ProductsDTO({
    required List<ProductDTO> products,
    required int total,
    required int skip,
    required int limit,
  }) = _ProductsDTO;

  factory ProductsDTO.fromJson(Map<String, dynamic> json) => _$ProductsDTOFromJson(json);
}

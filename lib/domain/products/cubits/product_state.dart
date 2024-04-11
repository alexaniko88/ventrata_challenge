import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ventrata_challenge/domain/products/entities/product_model.dart';

part 'product_state.freezed.dart';

@freezed
class ProductState with _$ProductState {
  const factory ProductState({
    required ProductStatus status,
    required List<ProductModel> products,
    Exception? exception,
  }) = _ProductState;
}

enum ProductStatus {
  initial,
  success,
  failure,
  unauthorized,
}

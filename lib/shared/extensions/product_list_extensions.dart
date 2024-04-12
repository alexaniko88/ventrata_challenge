import 'package:ventrata_challenge/domain/products/entities/product_model.dart';

extension ProductListExtensions on List<ProductModel> {
  List<ProductModel> get withAmount => where((element) => element.amount > 0).toList();
}
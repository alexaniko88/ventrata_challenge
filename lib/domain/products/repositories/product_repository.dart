import 'package:ventrata_challenge/domain/products/entities/product_model.dart';
import 'package:ventrata_challenge/shared/domain/entities/result.dart';
import 'package:ventrata_challenge/shared/exceptions/app_exception.dart';

abstract class ProductRepository {
  Future<Result<List<ProductModel>, AppException>> fetchProducts({required String token});
}

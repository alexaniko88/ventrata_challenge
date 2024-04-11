import 'package:injectable/injectable.dart';
import 'package:ventrata_challenge/data/data_mappers.dart';
import 'package:ventrata_challenge/data/datasources/product_datasource.dart';
import 'package:ventrata_challenge/domain/products/entities/product_model.dart';
import 'package:ventrata_challenge/domain/products/repositories/product_repository.dart';
import 'package:ventrata_challenge/shared/domain/entities/result.dart';
import 'package:ventrata_challenge/shared/exceptions/app_exception.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({
    required this.remoteDatasource,
  });

  final ProductRemoteDatasource remoteDatasource;

  @override
  Future<Result<List<ProductModel>, AppException>> fetchProducts({required String token}) async {
    final result = await remoteDatasource.fetchProducts(token: token);
    return result.fold(
      (productsDTO) => Result.success(productsDTO.products.map((dto) => dto.toModel()).toList()),
      (exception) => Result.failure(exception),
    );
  }
}

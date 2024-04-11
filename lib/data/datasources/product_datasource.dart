import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:ventrata_challenge/data/dtos/product_dto.dart';
import 'package:ventrata_challenge/shared/domain/entities/result.dart';
import 'package:ventrata_challenge/shared/exceptions/app_exception.dart';
import 'package:ventrata_challenge/shared/network/network_service.dart';

abstract class ProductRemoteDatasource {
  Future<Result<ProductsDTO, AppException>> fetchProducts({required String token});
}

@LazySingleton(as: ProductRemoteDatasource)
class ProductRemoteDatasourceImpl extends ProductRemoteDatasource {
  ProductRemoteDatasourceImpl(this.networkService);

  final NetworkService networkService;

  @override
  Future<Result<ProductsDTO, AppException>> fetchProducts({required String token}) async {
    try {
      final result = await networkService.get(
        '/products',
        extraHeaders: {
          'Authorization': 'Bearer $token',
        },
        queryParameters: {
          'total': 100,
          'limit': 10,
          // generate the random number between 0 and 90
          'skip': _generateRandomSkip(),
        },
      );
      return result.fold(
        (response) => Result.success(ProductsDTO.fromJson(response.data)),
        (exception) => Result.failure(exception),
      );
    } on Exception catch (e) {
      return Result.failure(
        AppException(
          identifier: 'getProducts',
          statusCode: StatusCode.dioException,
          message: e.toString(),
        ),
      );
    }
  }

  int _generateRandomSkip() {
    var rng = Random();
    return rng.nextInt(91); // 91 is exclusive upper bound, so it generates numbers from 0 to 90
  }
}

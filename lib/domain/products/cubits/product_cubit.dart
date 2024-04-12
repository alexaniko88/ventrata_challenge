import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ventrata_challenge/domain/products/cubits/product_state.dart';
import 'package:ventrata_challenge/domain/products/entities/product_model.dart';
import 'package:ventrata_challenge/domain/products/repositories/product_repository.dart';
import 'package:ventrata_challenge/domain/user/repositories/user_repository.dart';
import 'package:ventrata_challenge/shared/exceptions/app_exception.dart';

@injectable
class ProductCubit extends Cubit<ProductState> {
  ProductCubit({
    required this.productRepository,
    required this.userRepository,
  }) : super(const ProductState(
          status: ProductStatus.initial,
          products: [],
        ));

  final ProductRepository productRepository;
  final UserRepository userRepository;

  Timer? _timer;

  Future<void> fetchProducts() async {
    _fetchProducts();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      _fetchProducts();
    });
  }

  Future<void> getProducts() => _fetchProducts();

  void updateProductAmount({
    required int id,
    required int newAmount,
  }) {
      final updatedProducts = List<ProductModel>.from(state.products);
      final index = updatedProducts.indexWhere((product) => product.id == id);
      if (index != -1) {
        updatedProducts[index] = updatedProducts[index].copyWith(amount: newAmount);
        emit(
          ProductState(
            status: ProductStatus.success,
            products: updatedProducts,
          ),
        );
      }
  }

  void resetAllAmounts() {
    final updatedProducts = List<ProductModel>.from(state.products);
    for (var i = 0; i < updatedProducts.length; i++) {
      updatedProducts[i] = updatedProducts[i].copyWith(amount: 0);
    }
    emit(
      ProductState(
        status: ProductStatus.success,
        products: updatedProducts,
      ),
    );
  }

  Future<void> _fetchProducts() async {
    final tokenResult = await userRepository.getToken();
    tokenResult.fold(
      (token) async {
        final userResult = await productRepository.fetchProducts(token: token);
        userResult.fold(
          (newProducts) {
            final updatedProducts = List<ProductModel>.from(state.products);
            for (var newProduct in newProducts) {
              final index = updatedProducts.indexWhere((product) => product.id == newProduct.id);
              if (index != -1) {
                // Product already exists, increment the refreshed value
                updatedProducts[index] =
                    updatedProducts[index].copyWith(refreshed: updatedProducts[index].refreshed + 1);
              } else {
                // Product doesn't exist, add it to the list
                updatedProducts.add(newProduct);
              }
            }
            // Sort the products by the refreshed field in descending order
            updatedProducts.sort((a, b) => b.refreshed.compareTo(a.refreshed));
            emit(
              ProductState(
                status: ProductStatus.success,
                products: updatedProducts,
              ),
            );
          },
          (exception) {
            if (exception.statusCode == StatusCode.unauthorized) {
              emit(state.copyWith(status: ProductStatus.unauthorized));
            } else {
              emit(
                state.copyWith(
                  status: ProductStatus.failure,
                  exception: exception,
                ),
              );
            }
          },
        );
      },
      (exception) => emit(
        state.copyWith(
          status: ProductStatus.failure,
          exception: exception,
        ),
      ),
    );
  }

  void stopFetching() => _timer?.cancel();

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

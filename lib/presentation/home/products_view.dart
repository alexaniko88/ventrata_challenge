import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventrata_challenge/domain/login/cubits/login_cubit.dart';
import 'package:ventrata_challenge/domain/products/cubits/product_cubit.dart';
import 'package:ventrata_challenge/domain/products/cubits/product_state.dart';
import 'package:ventrata_challenge/shared/mixins/details_handler_mixin.dart';

class ProductsView extends StatelessWidget with DetailsHandlerMixin {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state.status == ProductStatus.unauthorized) {
            context.read<LoginCubit>().logout();
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case ProductStatus.initial:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ProductStatus.success:
              return ListView.separated(
                itemCount: state.products.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ListTile(
                    leading: product.thumbnail != null
                        ? Image.network(
                            product.thumbnail!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const SizedBox.shrink(),
                    title: Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text('Bought ${product.amount} times / Fetched ${product.refreshed} times'),
                    trailing: Text('${product.price}€'),
                    onTap: () async {
                      final cubit = context.read<ProductCubit>();
                      final result = await showDetails(context, product);
                      cubit.updateProductAmount(
                        id: product.id,
                        newAmount: result ?? 0,
                      );
                    },
                  );
                },
              );
            case ProductStatus.failure:
              return const Center(
                child: Text('Error loading products'),
              );
            case ProductStatus.unauthorized:
              return const Center(
                child: Text('Unauthorized'),
              );
          }
        },
      ),
    );
  }
}

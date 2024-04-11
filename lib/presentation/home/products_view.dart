import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ventrata_challenge/domain/products/cubits/product_cubit.dart';
import 'package:ventrata_challenge/domain/products/cubits/product_state.dart';
import 'package:ventrata_challenge/domain/products/entities/product_model.dart';
import 'package:ventrata_challenge/shared/navigation/navigation.dart';

class ProductsView extends StatelessWidget {
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
            context.goNamed(RoutePath.login.value);
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

  Future<int?> showDetails(
    BuildContext context,
    ProductModel productModel,
  ) {
    return showDialog<int?>(
      context: context,
      builder: (context) {
        int timesBought = productModel.amount;
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(productModel.title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productModel.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(productModel.price.toString()),
                Text(productModel.brand),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      color: Colors.green,
                      icon: const Icon(Icons.add),
                      iconSize: 50,
                      onPressed: () {
                        setState(() => timesBought++);
                      },
                    ),
                    const SizedBox(width: 10),
                    Text(timesBought.toString()),
                    const SizedBox(width: 10),
                    IconButton(
                      color: Colors.red,
                      icon: const Icon(Icons.remove),
                      iconSize: 50,
                      onPressed: () {
                        if (timesBought > 0) {
                          setState(() => timesBought--);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  Navigator.of(context).pop(timesBought);
                },
              ),
              TextButton(
                child: const Text('Remove'),
                onPressed: () {
                  Navigator.of(context).pop(0);
                },
              ),
            ],
          );
        });
      },
    );
  }
}

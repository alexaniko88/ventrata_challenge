import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ventrata_challenge/domain/products/cubits/product_cubit.dart';
import 'package:ventrata_challenge/domain/products/cubits/product_state.dart';
import 'package:ventrata_challenge/presentation/sale/payment_page.dart';
import 'package:ventrata_challenge/shared/extensions/product_list_extensions.dart';
import 'package:ventrata_challenge/shared/mixins/details_handler_mixin.dart';
import 'package:ventrata_challenge/shared/navigation/navigation.dart';

class SaleView extends StatelessWidget with DetailsHandlerMixin {
  const SaleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale'),
      ),
      body: Stack(
        children: [
          BlocConsumer<ProductCubit, ProductState>(
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
                  final products = state.products.withAmount;
                  return products.isEmpty
                      ? const Center(
                          child: Text("No items"),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.3),
                          child: ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return Card(
                                child: ListTile(
                                    title: Text(
                                      product.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Text(
                                      product.amount.toString(),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    onTap: () async {
                                      final cubit = context.read<ProductCubit>();
                                      final result = await showDetails(context, product);
                                      cubit.updateProductAmount(
                                        id: product.id,
                                        newAmount: result ?? 0,
                                      );
                                    }),
                              );
                            },
                          ),
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
          Visibility(
            visible: context.watch<ProductCubit>().state.products.withAmount.isNotEmpty,
            child: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.3,
                  vertical: 16,
                ),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final cubit = context.read<ProductCubit>();
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(builder: (context) => const PaymentPage()),
                      );
                      if (result == true) {
                        cubit.resetAllAmounts();
                      }
                    },
                    child: const Text('Checkout'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

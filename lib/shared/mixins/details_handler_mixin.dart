import 'package:flutter/material.dart';
import 'package:ventrata_challenge/domain/products/entities/product_model.dart';

mixin DetailsHandlerMixin {
  Future<int?> showDetails(
    BuildContext context,
    ProductModel productModel,
  ) {
    return showDialog<int?>(
      context: context,
      barrierDismissible: false,
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

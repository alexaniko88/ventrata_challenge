import 'package:flutter/material.dart';
import 'package:ventrata_challenge/presentation/sale/success_page.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop<bool>(context, false),
        ),
        title: const Text('Payment Page'),
      ),
      body: Center(
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (context) => const SuccessPage()),
              ).then((value) => Navigator.pop<bool>(context, value));
            },
            child: const Text('Pay'),
          ),
        ),
      ),
    );
  }
}

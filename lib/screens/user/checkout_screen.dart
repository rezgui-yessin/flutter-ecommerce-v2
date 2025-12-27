import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/constants.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Delivery Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
              initialValue: 'John Doe',
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
               initialValue: '123 Flutter St, Dart City',
            ),
             const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()),
               initialValue: '+1 234 567 890',
            ),
            const SizedBox(height: 32),
            const Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Card(
              child: ListTile(
                leading: Icon(Icons.money),
                title: Text('Cash on Delivery'),
                subtitle: Text('Pay when you receive the order'),
                trailing: Icon(Icons.check_circle, color: AppColors.secondaryLight),
              ),
            ),
            const SizedBox(height: 32),
            const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount:'),
                Text(
                  '\$${cart.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Mock Order Placement
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Order Placed!'),
                    content: const Text('Your order has been successfully placed. Thank you for shopping with us!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                           cart.clear();
                           Navigator.of(ctx).pop(); // Close Dialog
                           Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                        },
                        child: const Text('OK'),
                      )
                    ],
                  ),
                );
              },
               style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                   shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                ),
              child: const Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}

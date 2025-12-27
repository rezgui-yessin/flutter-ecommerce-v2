import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: const Icon(Icons.local_shipping),
            title: Text('Order #${1000 + index}'),
            subtitle: Text('Status: ${index == 0 ? 'Pending' : 'Delivered'}'),
            trailing: Text('\$${(50 + index * 10).toStringAsFixed(2)}'),
          ),
        );
      },
    );
  }
}

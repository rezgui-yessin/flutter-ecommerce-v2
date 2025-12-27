import 'package:flutter/material.dart';

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return ExpansionTile(
          title: Text('Order #${5000 + index}'),
          subtitle: Text('User: John Doe • \$${150 + index * 20}'),
          trailing: Chip(
            label: Text(index % 3 == 0 ? 'Pending' : (index % 3 == 1 ? 'Shipped' : 'Delivered')),
             backgroundColor: index % 3 == 0 ? Colors.orange[100] : (index % 3 == 1 ? Colors.blue[100] : Colors.green[100]),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text('2x T-Shirt'),
                  const Text('1x Jeans'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(onPressed: () {}, child: const Text('Mark Shipped')),
                      OutlinedButton(onPressed: () {}, child: const Text('Cancel Order')),
                    ],
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class ProductManagementScreen extends StatelessWidget {
  const ProductManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Product List for Management
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEditProductDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.image, size: 40),
              title: Text('Product Item ${index + 1}'),
              subtitle: Text('\$${(20 + index * 5)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showAddEditProductDialog(context, isEdit: true)),
                  IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {}),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddEditProductDialog(BuildContext context, {bool isEdit = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit Product' : 'Add Product'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Title')),
            TextField(decoration: InputDecoration(labelText: 'Price')),
            TextField(decoration: InputDecoration(labelText: 'Category')),
            TextField(decoration: InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: Text(isEdit ? 'Update' : 'Add')),
        ],
      ),
    );
  }
}

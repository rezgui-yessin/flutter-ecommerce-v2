import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../models/product.dart';

class ProductManagementScreen extends StatelessWidget {
  const ProductManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEditProductDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: Image.network(product.image, width: 40, height: 40, errorBuilder: (c,o,s) => const Icon(Icons.image)),
              title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text('\$${product.price}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue), 
                    onPressed: () => _showAddEditProductDialog(context, isEdit: true, product: product)
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red), 
                    onPressed: () => _confirmDelete(context, product.id)
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('No')),
          TextButton(onPressed: () async {
             Navigator.of(ctx).pop(); // Close dialog first
             try {
                await Provider.of<ProductProvider>(context, listen: false).deleteProduct(id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product deleted successfully')));
                }
             } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
                }
             }
          }, child: const Text('Yes')),
        ],
      ),
    );
  }

  void _showAddEditProductDialog(BuildContext context, {bool isEdit = false, Product? product}) {
    final titleController = TextEditingController(text: isEdit ? product?.title : '');
    final priceController = TextEditingController(text: isEdit ? product?.price.toString() : '');
    final descController = TextEditingController(text: isEdit ? product?.description : '');
    final imageController = TextEditingController(text: isEdit ? product?.image : 'https://i.pravatar.cc');
    
    // Category Handling
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    List<String> categories = productProvider.categories;
    String? selectedCategory = isEdit ? product?.category : (categories.isNotEmpty ? categories.first : null);

    // If editing and category not in list (edge case), add it temp
    if (isEdit && product != null && !categories.contains(product.category)) {
      categories = List.from(categories)..add(product.category); // Make mutable copy if needed
      selectedCategory = product.category;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(isEdit ? 'Edit Product' : 'Add Product'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
                  TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
                  
                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat.toUpperCase()))).toList(),
                    onChanged: (val) {
                      setState(() {
                         selectedCategory = val;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),
                  
                  TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
                  TextField(controller: imageController, decoration: const InputDecoration(labelText: 'Image URL')),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  if (selectedCategory == null) return;
                  
                  final newProduct = Product(
                    id: isEdit ? product!.id : DateTime.now().millisecondsSinceEpoch, // Temp ID for new
                    title: titleController.text,
                    price: double.tryParse(priceController.text) ?? 0.0,
                    description: descController.text,
                    category: selectedCategory!,
                    image: imageController.text,
                    rating: isEdit ? product!.rating : Rating(rate: 0, count: 0),
                  );

                  try {
                    if (isEdit) {
                       await Provider.of<ProductProvider>(context, listen: false).updateProduct(product!.id, newProduct);
                    } else {
                       await Provider.of<ProductProvider>(context, listen: false).addProduct(newProduct);
                    }
                    if (context.mounted) Navigator.pop(context);
                  } catch (e) {
                     // Error handling could go here
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }, 
                child: Text(isEdit ? 'Update' : 'Add')
              ),
            ],
          );
        }
      ),
    );
  }
}

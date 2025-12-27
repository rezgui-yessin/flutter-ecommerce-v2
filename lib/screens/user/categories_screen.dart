import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<ProductProvider>(context).categories;

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ListTile(
          leading: const Icon(Icons.category),
          title: Text(category.toUpperCase()),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Provider.of<ProductProvider>(context, listen: false).filterByCategory(category);
            // In a real app we might navigate to a specific listing page, 
            // but for now we filter and since HomeContent listens, it updates. 
            // However, we are in a different tab. 
            // Let's Mock navigation to a "CategoryProductsScreen" or just show a SnackBar 
            // since we use a filtered list in Home.
            // A better UX is to have a dedicated screen.
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text('Selected category: $category. Go to Home to see filtered items (or implement nav)')),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import '../../utils/constants.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;

  const CategoryProductsScreen({super.key, required this.categoryName});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch products for the selected category when the screen initializes
    Future.microtask(() =>
        Provider.of<ProductProvider>(context, listen: false)
            .filterByCategory(widget.categoryName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName.toUpperCase()),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          final products = productProvider.products;
          final isLoading = productProvider.isLoading;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (products.isEmpty) {
            return const Center(child: Text('No products found in this category.'));
          }

          return Padding(
            padding: const EdgeInsets.all(AppConstants.paddingSmall),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: 2,
                 childAspectRatio: 0.7,
                 crossAxisSpacing: 10,
                 mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(product: products[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

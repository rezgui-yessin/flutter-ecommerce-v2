import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import '../../utils/constants.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;
    final categories = productProvider.categories;
    final isLoading = productProvider.isLoading;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return CustomScrollView(
      slivers: [
        // Categories List (Horizontal)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingSmall),
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length + 1,
                itemBuilder: (context, index) {
                  final category = index == 0 ? 'All' : categories[index - 1];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ActionChip(
                      label: Text(category.toUpperCase()),
                      onPressed: () {
                        productProvider.filterByCategory(category);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        
        const SliverToBoxAdapter(child: Divider()),

        // Products Grid
        SliverPadding(
          padding: const EdgeInsets.all(AppConstants.paddingSmall),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ProductCard(product: products[index]);
              },
              childCount: products.length,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:products_app/features/products/presentation/widgets/product_card.dart';
import '../../data/products_provider.dart';
import '../../models/product_model.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  String _selectedFilter = 'all';
  String _selectedSort = 'none';

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productListNotifier);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Popular products',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                PopupMenuButton<String>(
                  position: PopupMenuPosition.under,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onSelected: (value) {
                    setState(() => _selectedFilter = value);
                  },

                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'all',
                      child: Text('All Products'),
                    ),
                    const PopupMenuItem(value: 'top', child: Text('Top Rated')),
                    const PopupMenuItem(
                      value: 'favorites',
                      child: Text('Favorites'),
                    ),
                  ],
                  child: OutlinedButton.icon(
                    onPressed: null,
                    iconAlignment: IconAlignment.end,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                      minimumSize: const Size(0, 34),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Filter',
                      style: TextStyle(fontSize: 13, color: Colors.black),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                PopupMenuButton<String>(
                  position: PopupMenuPosition.under,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onSelected: (value) {
                    setState(() => _selectedSort = value);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'price_low',
                      child: Text('Price: Low to High'),
                    ),
                    const PopupMenuItem(
                      value: 'price_high',
                      child: Text('Price: High to Low'),
                    ),
                    const PopupMenuItem(
                      value: 'rating',
                      child: Text('Top Rated'),
                    ),
                  ],
                  child: OutlinedButton.icon(
                    onPressed: null,
                    iconAlignment: IconAlignment.end,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                      minimumSize: const Size(0, 34),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Sort by',
                      style: TextStyle(fontSize: 13, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: productsAsync.when(
        data: (products) {
          List<ProductModel> filtered;

          if (_selectedFilter == 'top') {
            filtered = products.where((p) => p.isTopRated).toList();
          } else if (_selectedFilter == 'favorites') {
            filtered = products.where((p) => p.isFavorite).toList();
          } else {
            filtered = List.from(products);
          }

          if (_selectedSort == 'price_low') {
            filtered.sort((a, b) => a.price.compareTo(b.price));
          } else if (_selectedSort == 'price_high') {
            filtered.sort((a, b) => b.price.compareTo(a.price));
          } else if (_selectedSort == 'rating') {
            filtered.sort((a, b) => b.rating.compareTo(a.rating));
          }

          return GridView.builder(
            itemCount: filtered.length,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final product = filtered[index];
              final offSet = index.isOdd ? 12.0 : 0.0;
              return Transform.translate(
                offset: Offset(0, offSet),
                child: ProductCard(product: product),
              );
            },
          );
        },
        error: (error, stackTrace) =>
            Center(child: Text('Oops. Something went wrong: $error')),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

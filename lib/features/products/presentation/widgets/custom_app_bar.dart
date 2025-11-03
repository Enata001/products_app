import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/products_provider.dart';
import '../../models/product_model.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});


  String getFilterLabel(ProductFilter filter) {
    switch (filter) {
      case ProductFilter.topRated:
        return 'Top Rated';
      case ProductFilter.favorites:
        return 'Favorites';
      case ProductFilter.all:
      default:
        return 'All Products';
    }
  }

  String getSortLabel(ProductSort sort) {
    switch (sort) {
      case ProductSort.priceLowToHigh:
        return 'Price: Low to High';
      case ProductSort.priceHighToLow:
        return 'Price: High to Low';
      case ProductSort.rating:
        return 'Top Rated';
      default:
        return 'Sort by';
    }
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(productFilterProvider);
    final selectedSort = ref.watch(productSortProvider);


    return AppBar(
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
              PopupMenuButton<ProductFilter>(
                position: PopupMenuPosition.under,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onSelected: (value) {
                  ref.read(productFilterProvider.notifier).state = value;
                },

                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: ProductFilter.all,
                    child: Text('All Products'),
                  ),
                  const PopupMenuItem(
                    value: ProductFilter.topRated,
                    child: Text('Top Rated'),
                  ),
                  const PopupMenuItem(
                    value: ProductFilter.favorites,
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
                  label: Text(
                    getFilterLabel(selectedFilter),
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              PopupMenuButton<ProductSort>(
                position: PopupMenuPosition.under,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onSelected: (value) {
                  ref.read(productSortProvider.notifier).state = value;
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: ProductSort.priceLowToHigh,
                    child: Text('Price: Low to High'),
                  ),
                  const PopupMenuItem(
                    value: ProductSort.priceHighToLow,
                    child: Text('Price: High to Low'),
                  ),
                  const PopupMenuItem(
                    value: ProductSort.rating,
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
                  label: Text(
                    getSortLabel(selectedSort),
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

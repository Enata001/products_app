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
        return 'Filter';
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
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              PopupMenuButton<ProductFilter>(
                position: PopupMenuPosition.under,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onSelected: (value) {
                  ref
                      .read(productFilterProvider.notifier)
                      .state = value;
                },

                itemBuilder: (context) =>
                [
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
                child: _FilterTab(label:
                getFilterLabel(selectedFilter),
                ),
              ),

              const SizedBox(width: 6),

              PopupMenuButton<ProductSort>(
                position: PopupMenuPosition.under,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onSelected: (value) {
                  ref
                      .read(productSortProvider.notifier)
                      .state = value;
                },
                itemBuilder: (context) =>
                [
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
                child: _FilterTab(label:
                getSortLabel(selectedSort),
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

class _FilterTab extends StatelessWidget {
  final String label;

  const _FilterTab({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: EdgeInsets.symmetric(horizontal: 4,vertical: 0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme
              .of(context)
              .primaryColor,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 14,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

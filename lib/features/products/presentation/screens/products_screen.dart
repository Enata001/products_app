import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:products_app/features/products/presentation/widgets/product_card.dart';
import '../../data/products_provider.dart';
import '../widgets/custom_app_bar.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productListNotifier);
    final productsNotifier = ref.watch(productListNotifier.notifier);
    final selectedFilter = ref.watch(productFilterProvider);
    final selectedSort = ref.watch(productSortProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),

      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(productListNotifier),
        child: productsAsync.when(
          data: (products) {
            final filtered = productsNotifier.getFilteredSortedProducts(
              filter: selectedFilter,
              sort: selectedSort,
            );

            return GridView.builder(
              itemCount: filtered.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.79,
              ),
              itemBuilder: (context, index) {
                final product = filtered[index];
                final offSet = index.isOdd ? 10.0 : 0.0;
                return Transform.translate(
                  offset: Offset(0, offSet),
                  child: ProductCard(product: product),
                );
              },
            );
          },
          error: (error, stackTrace) =>
              Center(child: Text('Oops. Something went wrong: $error')),
          loading: () => Center(child: Text('Loading')),
        ),
      ),
    );
  }
}


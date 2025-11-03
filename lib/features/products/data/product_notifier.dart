import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:products_app/core/constants/api_endpoints.dart';
import 'package:products_app/features/products/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductsNotifier extends StateNotifier<AsyncValue<List<ProductModel>>> {
  ProductsNotifier() : super(AsyncValue.data([])){
    getProducts();
  }

  Future<void> getProducts() async {
    final url = Uri.parse(ApiEndpoints.products);
    try {
      final data = await http.get(url);
      if (data.statusCode == 200) {
        final response = jsonDecode(data.body) as Map<String, dynamic>;
        final items = response['products'] as List<dynamic> ;
        print(items);
        List<ProductModel> products = items
            .map((e) => ProductModel.fromJson(e))
            .toList();
        state = AsyncValue.data(products);
      }
    } catch (e) {
      state = AsyncValue.error('$e', StackTrace.current);
    }
  }
  void toggleFavorite(String productId) {
    final currentState = state;
    if (currentState is AsyncData<List<ProductModel>>) {
      final updatedList = currentState.value.map((product) {
        if (product.id == productId) {
          return product.copyWith(isFavorite: !product.isFavorite);
        }
        return product;
      }).toList();

      state = AsyncValue.data(updatedList);
    }
  }

  List<ProductModel> getFilteredSortedProducts({
    ProductFilter filter = ProductFilter.all,
    ProductSort sort = ProductSort.none,
  }) {
    final currentState = state;
    if (currentState is! AsyncData<List<ProductModel>>) return [];

    List<ProductModel> products = List.from(currentState.value);

    switch (filter) {
      case ProductFilter.topRated:
        products = products.where((p) => p.isTopRated).toList();
        break;
      case ProductFilter.favorites:
        products = products.where((p) => p.isFavorite).toList();
        break;
      case ProductFilter.all:
        break;
    }

    switch (sort) {
      case ProductSort.priceLowToHigh:
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSort.priceHighToLow:
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSort.rating:
        products.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ProductSort.none:
        break;
    }

    return products;
  }

}


// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class Product {
//   final String id;
//   final String name;
//   final double price;
//   const Product({required this.id, required this.name, required this.price});
// }
//
// final productListProvider = Provider<List<Product>>((ref) => const [
//   Product(id: 'p1', name: 'Laptop', price: 1200),
//   Product(id: 'p2', name: 'Mouse', price: 50),
//   Product(id: 'p3', name: 'Keyboard', price: 100),
// ]);
//
// final cartProvider =
// StateNotifierProvider<CartController, Map<String, int>>((ref) {
//   return CartController();
// });
//
// class CartController extends StateNotifier<Map<String, int>> {
//   CartController() : super({});
//
//   void addProduct(String productId) {
//     state = {
//       ...state,
//       productId: (state[productId] ?? 0) + 1,
//     };
//   }
//
//   void removeProduct(String productId) {
//     if (!state.containsKey(productId)) return;
//     final currentQty = state[productId]!;
//     if (currentQty > 1) {
//       state = {...state, productId: currentQty - 1};
//     } else {
//       final newState = Map<String, int>.from(state)..remove(productId);
//       state = newState;
//     }
//   }
//
//   void clearCart() => state = {};
// }
//
// final totalPriceProvider = Provider<double>((ref) {
//   final cart = ref.watch(cartProvider);
//   final products = ref.watch(productListProvider);
//   double total = 0;
//   for (final entry in cart.entries) {
//     final product =
//     products.firstWhere((p) => p.id == entry.key, orElse: () => const Product(id: 'x', name: 'Unknown', price: 0));
//     total += product.price * entry.value;
//   }
//   return total;
// });
//
// final checkoutProvider = AsyncNotifierProvider<CheckoutNotifier, bool>(CheckoutNotifier.new);
//
// class CheckoutNotifier extends AsyncNotifier<bool> {
//   @override
//   Future<bool> build() async => false;
//
//   Future<void> processCheckout(Ref ref) async {
//     final total = ref.read(totalPriceProvider);
//     if (total == 0) {
//       state = const AsyncError('Cart is empty', StackTrace.empty);
//       return;
//     }
//     state = const AsyncLoading();
//     await Future.delayed(const Duration(seconds: 2));
//     ref.read(cartProvider.notifier).clearCart();
//     state = const AsyncData(true);
//   }
// }
//
// final orderHistoryProvider =
// StateNotifierProvider<OrderHistoryController, List<double>>((ref) {
//   return OrderHistoryController();
// });
//
// class OrderHistoryController extends StateNotifier<List<double>> {
//   OrderHistoryController() : super([]);
//
//   void recordOrder(double amount) {
//     state = [...state, amount];
//   }
//
//   double get totalRevenue => state.fold(0, (a, b) => a + b);
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:products_app/features/products/data/product_notifier.dart';
import 'package:products_app/features/products/models/product_model.dart';

final productListNotifier =
    StateNotifierProvider<ProductsNotifier, AsyncValue<List<ProductModel>>>(
      (ref) => ProductsNotifier(),
    );

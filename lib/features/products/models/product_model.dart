class ProductModel {
  final String id;
  final String title;
  final String category;
  final double rating;
  final double price;
  final String thumbnail;
  bool isFavorite;

  ProductModel({
    required this.id,
    required this.title,
    required this.category,
    required this.rating,
    required this.price,
    required this.thumbnail,
    this.isFavorite = false,
  });

  bool get isTopRated => rating > 4.5;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: (json['id'] as int).toString(),
      title: json['title'] as String,
      category: json['category'] as String,
      rating: (json['rating'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'] as String,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  ProductModel copyWith({
    String? id,
    String? title,
    String? category,
    double? rating,
    double? price,
    String? thumbnail,
    bool? isFavorite,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      thumbnail: thumbnail ?? this.thumbnail,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'rating': rating,
      'price': price,
      'thumbnail': thumbnail,
      'isFavorite': isFavorite,
    };
  }
}

enum ProductFilter {
  all,
  topRated,
  favorites,
}

enum ProductSort {
  none,
  priceLowToHigh,
  priceHighToLow,
  rating,
}
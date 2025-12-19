class Product {
  final int id;
  final String name;
  final int price;
  final int stock;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.imageUrl,
  });

  // JSONをDartに変える
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      stock: json["stock"],
      imageUrl: json["thumbnail_image"] ?? "",
    );
  }

  // DartからJSONに変える
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "stock": stock,
      "imageUrl": imageUrl,
    };
  }
}

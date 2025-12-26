class Product {
  final int id;
  final String? name;
  final String? description;
  final int? price;
  final int? stock;
  final String? imageUrl;

  Product({
    required this.id,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.imageUrl,
  });

  // JSONをDartに変える
  factory Product.fromJson(Map<String, dynamic> json) {
    // TODO: これimageUrlだけ ?? 使っているけど他のはいいの？
    return Product(
      id: json["id"],
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      price: json["price"] ?? 0,
      stock: json["stock"] ?? 0,
      imageUrl: json["thumbnail_image"] ?? "",
    );
  }

  // DartからJSONに変える
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "stock": stock,
      "thumbnail_image": imageUrl,
    };
  }
}

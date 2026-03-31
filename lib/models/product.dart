class Product {
  final int id;
  final String? name;
  final String? description;
  final int? price;
  final int? stock;
  final String? imageUrl;
  final List<ItemMedia> itemMedias;

  Product({
    required this.id,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.imageUrl,
    required this.itemMedias,
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
      // item_mediasは存在していればItemMediaクラスに入れる
      itemMedias:
          (json['item_medias'] as List<dynamic>?)
              ?.map((e) => ItemMedia.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
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

class ItemMedia {
  final String imageUrl;
  final String movieThumbnailLarge;
  final String hlsUrl;
  final String moviePlayTime;

  ItemMedia({
    required this.imageUrl,
    required this.movieThumbnailLarge,
    required this.hlsUrl,
    required this.moviePlayTime,
  });

  factory ItemMedia.fromJson(Map<String, dynamic> json) {
    return ItemMedia(
      imageUrl: json['item_media'] ?? "",
      movieThumbnailLarge: json['movie_thumbnail_large'] ?? "",
      hlsUrl: json['hls_url'] ?? "",
      moviePlayTime: json['movie_play_time'] ?? "",
    );
  }
}

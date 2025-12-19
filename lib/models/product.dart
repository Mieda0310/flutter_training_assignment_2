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

// APIの返り値
// id": 659,
// "user_id": 82,
// "item_type": 5,
// "name": "物理　全体　在庫あり　購入制限あり",
// "description": "あ",
// "public_range": 1,
// "price": 100,
// "stock_flg": 1,
// "stock": 9,
// "max_purchase_flg": 1,
// "max_purchase_count": 1,
// "pin_flg": true,
// "capture_flg": false,
// "delivery_flg": true,
// "cc_registration_message": "クレジットカードはWebサイトでの登録が必要です。\n「accelfan demo アプリ」でWebサイトを検索してご登録ください。\nサイトURL： https:,
// "reservation_flag": false,
// "login_required_flg": false,
// "member_required_flg": false,
// "purchase_required_flg": true,
// "purchasable_flg": true,
// "purchased_flg": false,
// "twoshot_minutes": 0,
// "thumbnail_image": "https://demo.accel-fan.jp/media/item/20250828/b4c0945ee32049848c0e5f0b2506cd6c.jpg",
// "thumbnail_image_large": "https://demo.accel-fan.jp/media/item/20250828/b4c0945ee32049848c0e5f0b2506cd6c.large.jpg",
// "digital_content_category": 0,
// "artist_name": null,
// "artist_image": null,
// "item_medias": [
// {
// "item_media_id": 763,
// "media_type": 1,
// "item_media": "https://demo.accel-fan.jp/media/item_media/20250828/e59aa8f2bc734187bdb7be80eebc5ffa.jpg",
// "item_media_large": "https://demo.accel-fan.jp/media/item_media/20250828/e59aa8f2bc734187bdb7be80eebc5ffa.large.jpg",
// "movie_thumbnail_large": null,
// "hls_url": null,
// "movie_play_time": null,
// "movie_width": null,
// "movie_height": null
// }
// ],
// "purchase_quantity": 0,
// "quantity_purchased": 0,
// "is_streaming": false,
// "start_at": "2025/08/28 19:08:00",
// "end_at": null,
// "twoshot_start_at": null,
// "twoshot_end_at": null,
// "created_at": "2025/08/28 19:08:20",
// "updated_at": "2025/09/04 11:47:40",

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_training_assignment_2/models/product.dart';
import 'package:http/http.dart' as http;

// APIリクエストのヘッダー情報
final Map<String, String> requestHeader = {
  "Content-Type": "application/json",
  "Accept-Language": "ja",
  "Authorization": "Bearer ${dotenv.env["AUTHORIZATION"]}",
};

class ProductApi {
  final String domain = dotenv.env["API_DOMAIN"]!;

  Future fetchProducts() async {
    final String pass = "api/item/list";
    final String query = "";
    final url = Uri.parse(domain + pass + query);

    debugPrint("Api通信先のURL：$url");
    debugPrint("Api通信先のリクエストヘッダー：$requestHeader");

    // TODO:apiで400だよって出す、3つくらいの400、200、500で
    Map<String, dynamic> jsonList = {};

    try {
      final response = await http.post(
        url,
        headers: requestHeader,
        // jsonEncodeでDart言語をJSONに変換する
        body: jsonEncode({"start": 1}),
      );
      // debugPrint('response: ${response.body}');
      debugPrint('statusCode: ${response.statusCode}');

      // ステータスコード判定（スタータスコードでの分岐が多くなるならswitchを使うのもいい）
      if (response.statusCode == 200) {
        debugPrint("statusCodeは200です。");
      } else if (response.statusCode == 400) {
        debugPrint("statusCodeは400です。");
        return [];
      } else if (response.statusCode == 500) {
        debugPrint("statusCodeは500です。");
        return [];
      } else {
        debugPrint("statusCodeは200、400、500以外のどれでもありません。");
        return [];
      }

      // APIで取得したJSONをDart言語にする
      jsonList = jsonDecode(response.body);
    } catch (error) {
      debugPrint("ListViewのAPI通信でエラーが発生しました。");
      debugPrint(error.toString());
      return [];
    }
    // ボディーの中にあるitemsのみを取得する
    final List items = jsonList["items"] as List;
    // itemsを1つずつに分解してProductモデルに入れ込む
    final List<Product> products = items.map((item) {
      return Product.fromJson(item);
    }).toList();

    return products;
  }

  // 商品詳細からデータ取得
  Future fetchProductDetail(int productId) async {
    final String pass = "api/item/detail";
    final String query = "";
    final url = Uri.parse(domain + pass + query);

    debugPrint("送信先エンドポイント：$url");
    try {
      final response = await http.post(
        url,
        headers: requestHeader,
        body: jsonEncode({"item_id": productId}),
      );

      debugPrint("ステータスコード：${response.statusCode}");

      if (response.statusCode != 200) {
        debugPrint("商品詳細のデータ取得時のステータスコードが200以外です。");
      }

      final Map<String, dynamic> jsonItem = jsonDecode(response.body);
      final Product product = Product.fromJson(jsonItem);
      return product;
    } catch (error) {
      debugPrint("商品詳細のデータ取得に失敗しました。$error");
    }
  }
}

// TODO: カートの購入処理
Future fetchPurchase() async {}

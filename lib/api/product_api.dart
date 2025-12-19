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
  final String pass = "";
  final String query = "";

  Future fetchProducts() async {
    final url = Uri.parse(domain + pass + query);
    debugPrint("Api通信先のURL：$url");
    debugPrint("Api通信先のリクエストヘッダー：$requestHeader");

    final response = await http.post(
      url,
      headers: requestHeader,
      // jsonEncodeでDart言語をJSONに変換する
      body: jsonEncode({"start": 1}),
    );
    debugPrint('statusCode: ${response.statusCode}');
    // debugPrint('response: ${response.body}');

    // APIで取得したJSONをDart言語にする
    final jsonList = jsonDecode(response.body);
    // ボディーの中にあるitemsのみを取得する
    final List items = jsonList["items"];
    // itemsを1つずつに分解してProductモデルに入れ込む
    final List<Product> products = items.map((item) {
      return Product.fromJson(item);
    }).toList();

    return products;
  }
}

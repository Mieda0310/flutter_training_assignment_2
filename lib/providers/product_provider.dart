import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_training_assignment_2/api/product_api.dart';
import 'package:flutter_training_assignment_2/models/product.dart';

// APIを叩き、商品一覧を取得してきてくれるプロバイダ
// なので、API実行〜プロバイダに状態管理まで行なってくれる
// ref.watch(productProvider)を実行することで、productProviderのAPIが叩かれる
final productProvider = FutureProvider<List<Product>>((ref) async {
  return await ProductApi().fetchProducts();
});

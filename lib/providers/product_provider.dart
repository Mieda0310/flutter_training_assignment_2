import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_training_assignment_2/api/product_api.dart';
import 'package:flutter_training_assignment_2/models/product.dart';

// APIを叩き、商品一覧を取得してきてくれるプロバイダ
// なので、API実行〜プロバイダに状態管理まで行なってくれる
// ref.watch(productProvider)を実行することで、productProviderのAPIが叩かれる

// TODO: statenotifierprovider asyncvalue futureProvierの違いを知り、どっちを使うかを決める

// #### MEMO ####
// FutureProvider：APIなどからデータを非同期で取得するもの
// AsyncValue：FutureProviderの結果を「ローディング中・成功・失敗」をUIで表現するもの
// StateNotifierProvider：UIをユーザー自身が手動で変えたときなどに使う（カート追加やいいね）

// 商品一覧の取得
final productsProvider = FutureProvider<List<Product>>((ref) async {
  return await ProductApi().fetchProducts();
});

// FutureProvider.familyを使うと引数を使うことができるので、各商品のIDを引数とする
// 商品詳細の取得
final productDetailProvider = FutureProvider.family<Product, int>((
  ref,
  productId,
) async {
  return await ProductApi().fetchProductDetail(productId);
});

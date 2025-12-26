import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_training_assignment_2/api/product_api.dart';
import 'package:flutter_training_assignment_2/models/product.dart';
import 'package:flutter_training_assignment_2/providers/cart_provider.dart';
import 'package:flutter_training_assignment_2/providers/product_provider.dart';
import 'package:flutter_training_assignment_2/widgets/app_bar_widget.dart';

class ProductDetail extends ConsumerWidget {
  final int id;
  const ProductDetail({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProduct = ref.watch(productDetailProvider(id));

    // 現在のカウント数を出力している
    final cartQuantity = ref.watch(quantityProvider);
    final qtyProvider = ref.read(quantityProvider.notifier);

    // カート内の商品数を変更するためのインスタンス
    // readの意図は、ボタンを押下しただけでUIは変更しないから
    final cartNotifier = ref.read(cartProvider.notifier);

    return asyncProduct.when(
      loading: () {
        debugPrint("商品詳細のデータを取得中です。");
        // データ取得中はローディングを返す
        return Center(child: CircularProgressIndicator());
      },
      error: (err, stack) {
        debugPrint("商品詳細のデータの取得に失敗しました。$err");
        return Center(
          child: Text(
            "商品詳細のデータの取得に失敗しました。$err",
            style: TextStyle(color: Colors.red),
          ),
        );
      },
      data: (product) {
        return Scaffold(
          appBar: AppBarWidget(title: "商品詳細"),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  product.imageUrl ?? "",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                  // 商品画像が存在しない場合はデフォルトのアイコンを表示させる
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      width: double.infinity,
                      child: const Icon(
                        Icons.error,
                        size: 60,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "商品名",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "商品名：${product.name}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("価格", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        product.price.toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "商品説明",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(product.description.toString()),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // カートに追加するボタン群
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text("個数"),
                    ),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: OutlinedButton(
                        // 角が丸くなっているのを視覚にする
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          side: BorderSide(
                            // カートのカウント数によってボタンを押せない場合は色を薄くする
                            color: cartQuantity > 1
                                ? Colors.grey
                                : Colors.grey.withAlpha(80),
                          ),
                        ),
                        onPressed: () {
                          // -1する
                          if (cartQuantity > 1) {
                            qtyProvider.decrement();
                          } else {
                            // nullにするとボタンが押せなくなる
                            null;
                          }
                        },
                        child: Icon(Icons.remove),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(cartQuantity.toString()),
                    ),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: OutlinedButton(
                        // 角が丸くなっているのを視覚にする
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () {
                          // +1する
                          qtyProvider.increment();
                        },
                        child: Icon(Icons.add),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(right: 16)),
                  ],
                ),
                // カートに追加ボタン
                Container(
                  padding: const EdgeInsets.only(top: 24, right: 16, left: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // ここにカートへ追加する処理を記述
                        cartNotifier.add(product, cartQuantity);
                        debugPrint("カートに${product.name}を追加しました。");

                        // スナックバーを表示
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("商品をカートに追加しました。"),
                            duration: Duration(seconds: 3),
                            behavior: SnackBarBehavior.fixed,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "カートに追加",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // カードに追加ボタンなどのフッター
        );
      },
    );
  }
}

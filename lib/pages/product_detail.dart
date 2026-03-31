import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_training_assignment_2/api/product_api.dart';
import 'package:flutter_training_assignment_2/models/product.dart';
import 'package:flutter_training_assignment_2/providers/cart_provider.dart';
import 'package:flutter_training_assignment_2/providers/product_provider.dart';
import 'package:flutter_training_assignment_2/widgets/app_bar_widget.dart';
import 'package:flutter_training_assignment_2/widgets/image_download_dialog.dart';
import 'package:flutter_training_assignment_2/widgets/simple_video_player.dart';
import 'package:video_player/video_player.dart';

class ProductDetail extends ConsumerStatefulWidget {
  final int id;
  const ProductDetail({super.key, required this.id});

  @override
  ConsumerState<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends ConsumerState<ProductDetail> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final asyncProduct = ref.watch(productDetailProvider(widget.id));

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
                SizedBox(
                  height: 250,
                  child: PageView.builder(
                    itemCount: product.itemMedias.isEmpty
                        ? 1
                        : product.itemMedias.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final media = product.itemMedias[index];
                      final imageUrl = product.itemMedias.isEmpty
                          ? product.imageUrl
                          : media.imageUrl;
                      final isVideo = media.hlsUrl.isNotEmpty;

                      if (isVideo) {
                        return Stack(
                          children: [
                            Center(
                              child: SimpleVideoPlayer(
                                // keyが変更されると動画再生画面を切り替えるとWidgetが作り替えられることで動画再生が止まる
                                key: ValueKey(index),
                                videoUrl: media.hlsUrl,
                              ),
                            ),
                            Positioned(
                              right: 1,
                              child: DownloadButtonWidget(
                                imageUrl: imageUrl ?? "",
                                isVideo: true,
                              ),
                            ),
                          ],
                        );
                      }
                      return Stack(
                        children: [
                          Image.network(
                            imageUrl ?? "",
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          Positioned(
                            right: 1,
                            child: DownloadButtonWidget(
                              imageUrl: imageUrl ?? "",
                              isVideo: false,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Center(
                  child: Text(
                    "${currentIndex + 1}/${product.itemMedias.length}",
                  ),
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

class DownloadButtonWidget extends StatelessWidget {
  final String imageUrl;
  final bool isVideo;

  const DownloadButtonWidget({
    super.key,
    required this.imageUrl,
    this.isVideo = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        // タップしたら画像または動画のダウンロードダイアログを表示させる
        showDialog(
          context: context,
          builder: (_) =>
              ImageDownloadDialog(imageUrl: imageUrl, isVideo: isVideo),
        );
      },
      icon: const Icon(Icons.download, color: Colors.black),
    );
  }
}

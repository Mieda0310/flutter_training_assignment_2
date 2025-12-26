import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_training_assignment_2/api/product_api.dart';
import 'package:flutter_training_assignment_2/providers/cart_provider.dart';
import 'package:flutter_training_assignment_2/providers/product_provider.dart';
import 'package:flutter_training_assignment_2/widgets/app_bar_widget.dart';
import 'package:go_router/go_router.dart';

class Cart extends ConsumerWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    // カート内の商品数を変更するためのインスタンス
    // readの意図は、ボタンを押下しただけでUIは変更しないから
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBarWidget(title: "カート", isShowActions: false),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            // カートの合計と金額
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // TODO: 合計金額を求める計算式を作る
                children: [
                  Text(
                    "合計",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    // cart_providerに定義した合計金額を求めるproviderから金額を取得できる
                    "￥${ref.watch(cartTotalPriceProvider).toString()}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            Expanded(
              child: cartItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartItems[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // カートの内容
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  //////  カートに追加した画像と名前と値段 //////
                                  Image.network(
                                    cartItem.product.imageUrl ?? "",
                                    fit: BoxFit.cover,
                                    height: 60,
                                    width: 60,
                                    // 商品画像が存在しない場合はデフォルトのアイコンを表示させる
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 40,
                                        child: const Icon(
                                          Icons.error,
                                          size: 60,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),

                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 24,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cartItem.product.name.toString(),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            child: Text(
                                              "￥${cartItem.product.price.toString()} × ${cartItem.quantity} = ￥${(cartItem.product.price! * cartItem.quantity).toString()}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  //////  ここからカートの個数変更と削除 //////
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: OutlinedButton(
                                      // 角が丸くなっているのを視覚にする
                                      style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        side: BorderSide(
                                          color: Colors.grey.withAlpha(0),
                                        ),
                                      ),
                                      onPressed: () {
                                        // -1する
                                        if (cartItem.quantity > 1) {
                                          cartNotifier.decrement(
                                            cartItem.product,
                                          );
                                        } else {
                                          // nullにするとボタンが押せなくなる
                                          null;
                                        }
                                      },
                                      child: Icon(Icons.remove),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(cartItem.quantity.toString()),
                                  ),
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: OutlinedButton(
                                      // 角が丸くなっているのを視覚にする
                                      style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        side: BorderSide(
                                          color: Colors.grey.withAlpha(0),
                                        ),
                                      ),
                                      onPressed: () {
                                        // +1する
                                        cartNotifier.add(cartItem.product, 1);
                                      },
                                      child: Icon(Icons.add),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(right: 16)),
                                  InkWell(
                                    onTap: () {
                                      debugPrint(
                                        "カートから${cartItem.product.name}を削除する",
                                      );
                                      cartNotifier.remove(cartItem.product.id);
                                    },
                                    child: Text("削除"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(child: Text("カートに商品がありません。")),
            ),
          ],
        ),
      ),
      // カードに追加ボタンなどのフッター
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 購入ボタンとカートを空にするボタンはカートに何も入っていない場合は非活性化する
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cartItems.length > 0
                    ? () {
                        // 購入処理を記述
                        debugPrint("購入するボタンを押下しました。");
                        cartNotifier.purchase();
                        context.push("/thunks");
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "購入する",
                  style: TextStyle(
                    color: cartItems.length > 0 ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: cartItems.length > 0
                  ? OutlinedButton(
                      onPressed: cartItems.length > 0
                          ? () {
                              // ここにカートを空にする処理を記述
                              // 下から浮き出るモーダルのようなものを作りたいので、BottomSheetを使う
                              showModalBottomSheet(
                                context: context,
                                // 角を丸めたい
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "カートを空にしますか？",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          "全ての商品が削除されます（元に戻せません）。",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        SizedBox(height: 12),
                                        SizedBox(
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            onPressed: () {
                                              // ここに空にする処理を記述する
                                              cartNotifier.reset();
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              side: BorderSide(
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                            child: Text(
                                              "空にする",
                                              style: TextStyle(
                                                color: Colors.redAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // 戻るボタンのためモーダルを閉じる
                                              // go_routerを使っている場合でもNavigatorのスタックに乗っているためNavigator.popで戻せる
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              "戻る",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(color: Colors.redAccent),
                      ),
                      child: Text(
                        "カートを空にする",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : // カートに何もない場合はボタンそのものを変える
                    ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "カートを空にする",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_training_assignment_2/models/cart_item.dart';
import 'package:flutter_training_assignment_2/models/product.dart';

// カートのカウント数を変更するもので、intのみを扱うことができるものを明示的に記述できる
class QuantityNotifier extends Notifier<int> {
  @override
  // カートに追加する初期値を1として設定する
  int build() => 1;

  // stateはNotifierが所持している状態のこと
  void increment() {
    state++;
  }

  void decrement() {
    // カートの追加は0以下はあり得ないので0以下にならないようにする
    if (state > 1) state--;
  }
}

// カートの数量を変更
// autoDisposeを使うことで、商品詳細ページから離れた際に再度実行されるようになる
final quantityProvider = NotifierProvider.autoDispose<QuantityNotifier, int>(
  QuantityNotifier.new,
);

// カートの追加・削除・更新を行う
class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return [];
  }

  void add(Product product, int quantity) {
    // indexWhereで配列の要素番号を取得できる
    final int index = state.indexWhere((e) => e.product.id == product.id);

    // すでにカートに登録してある商品の数量を変更する場合
    if (index >= 0) {
      // stateを直接変更することはできないので新しい変数に置き換えて登録し直す
      final currentCart = [...state];
      final updateCart = currentCart[index];
      currentCart[index] = updateCart.copyWith(
        quantity: updateCart.quantity + quantity,
      );
      state = currentCart;
      // 新しく商品をカートに追加した場合
    } else {
      state = [...state, CartItem(product: product, quantity: quantity)];
    }
  }

  void decrement(Product product) {
    // indexWhereで配列の要素番号を取得できる
    final int index = state.indexWhere((e) => e.product.id == product.id);

    // stateを直接変更することはできないので新しい変数に置き換えて登録し直す
    final currentCart = [...state];
    final updateCart = currentCart[index];

    if (updateCart.quantity <= 1) return;
    currentCart[index] = updateCart.copyWith(quantity: updateCart.quantity - 1);
    state = currentCart;
  }

  // カートの商品を削除
  void remove(int productId) {
    // whereで引数のproductIdと一致しないものを全て返し、一致したものは返さない
    state = state.where((e) => e.product.id != productId).toList();
  }

  // カートの中身を全て削除
  void reset() {
    state = [];
  }

  // カートの購入処理
  void purchase() {
    // 本来はここで購入処理を記述するが、今回は状態を全て初期化するのみにする
    state = [];
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(
  CartNotifier.new,
);

// カート内の総個数を求める
final cartTotalQuantityProvider = Provider<int>((ref) {
  // まずはカート内のステートを全て取得
  final cartItems = ref.watch(cartProvider);
  // その後、cartItems内のカートに入れた商品数を全て計算する
  return cartItems.fold(0, (sum, item) => sum + item.quantity);
});

// カート内の合計金額を求める
final cartTotalPriceProvider = Provider<int>((ref) {
  final cartItems = ref.watch(cartProvider);
  return cartItems.fold<int>(
    0,
    (sum, item) => sum + item.product.price! * item.quantity,
  );
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_training_assignment_2/providers/cart_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:badges/badges.dart' as badges;

// AppBarは高さを指定してあげる必要があるため、PreferredSizeWidgetを使用する
class AppBarWidget extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final bool isShowActions;

  AppBarWidget({super.key, this.title, this.isShowActions = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalQuantity = ref.watch(cartTotalQuantityProvider);

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(title.toString()),
      // ヘッダーのアイコンは複数追加することができる
      actions: isShowActions
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: badges.Badge(
                  // showBadge = falseでアイコンの右上にある表示数を非表示にできる
                  // TODO: カートへの商品追加数が10を超えるとカートアイコンが隠れてしまうので対策必要
                  showBadge: totalQuantity > 0,
                  badgeContent: Text(totalQuantity.toString()),
                  position: badges.BadgePosition.topEnd(top: 0, end: 0),
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      // ボタン押下でカート画面に遷移させる
                      context.push("/cart");
                    },
                  ),
                ),
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

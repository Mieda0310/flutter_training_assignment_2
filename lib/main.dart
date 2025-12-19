import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_training_assignment_2/pages/detail_item.dart';
import 'package:flutter_training_assignment_2/providers/product_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => MyHomePage()),
    GoRoute(
      path: "/detail/:id",
      builder: (context, state) {
        // state.pathParametersでURLのパラメータを取得できる
        return DetailItem(id: int.parse(state.pathParameters["id"]!));
      },
    ),
  ],
);

void main() async {
  // .evnを読み込むための記述
  await dotenv.load(fileName: ".env");
  // riverpodを使う際はMyAppを囲むことでアプリ全体で使用可能になる
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      // Go Routerを使用する際はhomeを使ってはいけない
      // home: MyHomePage(title: '商品一覧'),
    );
  }
}

// TODO: まずは商品一覧画面、詳細画面を作成する：完了
// TODO: go routerを使用して画面を遷移する：完了
// TODO: 商品一覧画面の商品UIを2つだけ仮で作成してみる：完了
// TODO: APIにリクエストを送り、商品リストを取得する。商品はRiver Podでstateとして管理する。：着手中
// TODO: 商品一覧画面に5で取得した商品を落とし込み、UIを作成する（完了したら一旦レビュー依頼）。：未着手

// ConsumerWidgetとは、riverpodのProviderを使えるWidget
class MyHomePage extends ConsumerWidget {
  // const MyHomePage({super.key, required this.title});
  // final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProduct = ref.watch(productProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("商品一覧"),
      ),
      body: asyncProduct.when(
        loading: () {
          // データ取得中のローディングを表示する
          debugPrint("ローディング中です");
        },
        error: (err, stack) {
          // データ取得中にエラーがあった際に表示する
          debugPrint("エラーが発生しました。$err");
        },
        data: (products) {
          return GridView.builder(
            padding: EdgeInsets.only(right: 10, left: 10),
            // itemCountで表示する数を指定可能
            itemCount: products.length,

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              // crossAxisCountで列に表示する数を指定できる
              crossAxisCount: 2,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (BuildContext context, int index) {
              final product = products[index];
              return InkWell(
                // 商品一覧の商品をタップすろとonTapが発動する
                onTap: () {
                  // これまで使用してきたNavigator.pushは使わずに、go routerを使用して遷移させる
                  // ページ遷移させるときはpathを書いて遷移させる
                  context.push("/detail/${index + 1}");
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    right: 8,
                    left: 8,
                    bottom: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        product.imageUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        // 画像が存在しない、または表示できない場合はデフォルトアイコンを表示させる
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 180,
                            width: double.infinity,
                            child: const Icon(
                              Icons.error,
                              size: 60,
                              color: Colors.grey,
                            ),
                          );
                          // 画像を表示させる場合、一時的にネット経由で画像を取得しているが、Asset画像として登録して表示させる
                          return Image.network(
                            "https://hugeicons.com/api/og?uuid=alert-circle-solid-rounded",
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0, left: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  "${product.price}円",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

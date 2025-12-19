import 'package:flutter/material.dart';
import 'package:flutter_training_assignment_2/api/product_api.dart';

class DetailItem extends StatelessWidget {
  const DetailItem({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("商品詳細"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: 画像や商品名は仮で作成しているので変える
            Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQN_RwYJNB9TZhSU6h3tODv0bI2dVTHnlosig&s",
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("商品名はこれです"), Text("商品名：${id}")],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("価格"), Text("商品名：${id}")],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("商品説明"), Text("商品名：${id}")],
              ),
            ),
            const SizedBox(height: 20),

            // カートに追加するボタン群
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text("個数"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: -1する
                  },
                  child: Icon(Icons.remove),
                ),
                Padding(padding: const EdgeInsets.all(16), child: Text("1")),
                ElevatedButton(
                  onPressed: () {
                    // TODO: +1する
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // カードに追加ボタン
            Center(
              child: Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // ここにカートへ追加する処理を記述
                  },
                  child: Text("カートに追加"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final instance = ProductApi();
          instance.fetchProducts();
        },
        child: Text("API通信開始"),
      ),
    );
  }
}

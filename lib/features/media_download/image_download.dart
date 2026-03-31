import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ImageDownload {
  // ボタン押下で画像をダウンロード（dio、Gal, path_providerを使う）
  // 全体の流れはこれ
  // ① URL取得
  // ② Dioでダウンロード
  // ③ 一時ファイルに保存
  // ④ Galでギャラリー保存
  // ⑤ 一時ファイルを削除
  // ⑥ 完了表示

  //  画像のURLを取得するためのdioをインスタンス化する
  final Dio dio = Dio();

  Future<void> downloadAndSaveImage(String imageUrl) async {
    // 画像のダウンロードの実装

    // まずはダウンロード権限があるかを確認する
    final hasAccess = await Gal.hasAccess();
    // 権限がない状態であれば権限確認を行う
    if (!hasAccess) {
      final granted = await Gal.requestAccess();
      // 権限確認でも拒否されたら処理を終了する
      if (!granted) {
        throw Exception("ギャラリーへのアクセスが許可されていません");
      }
    }

    // 一時ディレクトリを取得する（path_providerの機能）
    final tempDir = await getTemporaryDirectory();
    // 取得したディレクトリを完全なpathにする
    final filePath =
        "${tempDir.path}/download_image_${DateTime.now().microsecondsSinceEpoch}.jpg";
    // dioでURLにアクセスし、画像データを取得したら、filePathにファイルとして保存
    await dio.download(imageUrl, filePath);
    // 作成した画像ファイルを端末内の写真フォルダに投入
    await Gal.putImage(filePath);
    // 画像を端末に投入後、一時ファイルとして作成したものを削除
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}

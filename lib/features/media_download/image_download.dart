import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:video_compress/video_compress.dart';

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

  Future<void> downloadAndSaveImage(String imageUrl, bool isVideo) async {
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
    final filePath = isVideo
        ? "${tempDir.path}/download_image_${DateTime.now().microsecondsSinceEpoch}.mp4"
        : "${tempDir.path}/download_image_${DateTime.now().microsecondsSinceEpoch}.jpg";
    // dioでURLにアクセスし、画像データを取得したら、filePathにファイルとして保存
    await dio.download(imageUrl, filePath);

    // 画像と動画でダウンロードが異なるのは、端末内の保存方法のみのため、分岐で分ける
    if (isVideo) {
      // 元のファイルサイズ
      final originalSize = await File(filePath).length();

      // 写真フォルダに投入する前に圧縮する
      final compressedFile = await compressVideoFile(filePath);

      // 圧縮後のファイルサイズ
      final compressedSize = await compressedFile.length();

      // 圧縮前後でのファイルサイズを出力
      double toMB(int bytes) => bytes / 1024 / 1024;
      print("圧縮前: ${toMB(originalSize).toStringAsFixed(2)} MB");
      print("圧縮後: ${toMB(compressedSize).toStringAsFixed(2)} MB");

      // 作成した動画ファイルを端末内の写真フォルダに投入
      await Gal.putVideo(compressedFile.path);
      // 圧縮したキャッシュを削除する
      await VideoCompress.deleteAllCache();
    } else {
      // 作成した画像ファイルを端末内の写真フォルダに投入
      await Gal.putImage(filePath);
    }

    // 画像を端末に投入後、一時ファイルとして作成したものを削除
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  // video_compressのパッケージを使用し、動画を圧縮する
  // ダウンロード前には使えないので、ファイルとして保存した後に圧縮する
  Future<File> compressVideoFile(String filePath) async {
    final info = await VideoCompress.compressVideo(
      filePath,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );

    final compressedFile = info?.file;
    print("ファイルの圧縮開始");
    print(compressedFile);
    if (compressedFile == null) {
      throw Exception("動画の圧縮に失敗しました。");
    }

    return compressedFile;
  }
}

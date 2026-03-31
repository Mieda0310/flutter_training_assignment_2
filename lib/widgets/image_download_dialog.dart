import 'package:flutter/material.dart';
import 'package:flutter_training_assignment_2/features/media_download/image_download.dart';

class ImageDownloadDialog extends StatefulWidget {
  final String imageUrl;

  const ImageDownloadDialog({super.key, required this.imageUrl});

  @override
  State<ImageDownloadDialog> createState() => _ImageDownloadDialogState();
}

class _ImageDownloadDialogState extends State<ImageDownloadDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          const Text(
            '画像をダウンロードしますか？',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                // 画像のダウンロード中は処理しない
                onPressed: isLoading
                    ? null
                    : () async {
                        print("ダウンロード処理の開始, path:image_download_dialog.dart");
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          final imageDown = ImageDownload();
                          await imageDown.downloadAndSaveImage(widget.imageUrl);

                          // 画面描写が完了していない間は処理しない
                          if (!mounted) return;

                          // ダウンロードが完了したことをSnackBarで表示
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('画像を保存しました')),
                          );

                          Navigator.of(context, rootNavigator: true).pop();
                        } catch (e) {
                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("画像ダウンロードに失敗しました。$e")),
                          );
                        } finally {
                          if (!mounted) return;
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        "ダウンロード",
                        style: TextStyle(color: Colors.black),
                      ),
              ),
              TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                child: Text(
                  "戻る",
                  style: TextStyle(
                    color: isLoading ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

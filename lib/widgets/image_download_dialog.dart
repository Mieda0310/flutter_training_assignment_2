import 'package:flutter/material.dart';
import 'package:flutter_training_assignment_2/features/media_download/image_download.dart';

class ImageDownloadDialog extends StatefulWidget {
  final String imageUrl;
  final bool isVideo;

  const ImageDownloadDialog({
    super.key,
    required this.imageUrl,
    required this.isVideo,
  });

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
          Text(
            widget.isVideo ? '動画をダウンロードしますか？' : '画像をダウンロードしますか？',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                // ダウンロード中は処理しない
                onPressed: isLoading
                    ? null
                    : () async {
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          final imageDown = ImageDownload();
                          await imageDown.downloadAndSaveImage(
                            widget.imageUrl,
                            widget.isVideo,
                          );

                          // 画面描写が完了していない間は処理しない
                          if (!mounted) return;

                          // ダウンロードが完了したことをSnackBarで表示
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                widget.isVideo ? '動画を保存しました' : '画像を保存しました',
                              ),
                            ),
                          );

                          Navigator.of(context, rootNavigator: true).pop();
                        } catch (e) {
                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("ダウンロードに失敗しました。$e")),
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

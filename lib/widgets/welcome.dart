import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showWelcomeDialog(BuildContext context) async {
  // SharedPreferencesはKeyとValueで管理する
  const _key = 'welcome_dialog_shown';
  final prefs = await SharedPreferences.getInstance();
  final shown = prefs.getBool('welcome_dialog_shown') ?? false;

  debugPrint("ようこそを表示：$shown");
  // 一度表示させたら表示させない
  if (shown) return;

  debugPrint("ようこそを表示させます");

  await showDialog(
    context: context,
    builder: (_) => Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          const Text('ようこそ', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          InkWell(
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              // 始めるを押下したらフラグを付けて表示させなくする
              await prefs.setBool(_key, true);
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text('はじめる'),
            ),
          ),
        ],
      ),
    ),
  );
  debugPrint("ようこそを表示させました");
}

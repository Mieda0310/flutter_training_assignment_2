import 'package:flutter/material.dart';
import 'package:flutter_training_assignment_2/widgets/app_bar_widget.dart';
import 'package:go_router/go_router.dart';

class Thunks extends StatelessWidget {
  const Thunks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "カート", isShowActions: false),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("ご購入ありがとうございました。"),
            SizedBox(height: 32),
            InkWell(
              onTap: () {
                context.push("/");
              },
              child: Text(
                "Homeに戻る",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

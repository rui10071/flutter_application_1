import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'theme.dart';
import 'execution_screen.dart'; // 追加
import 'training_model.dart'; // 追加


class CameraPermissionScreen extends StatelessWidget {
  final TrainingMenu menu; // どのメニューを実行するか受け取る


  // コンストラクタでmenuを必須にする
  const CameraPermissionScreen({required this.menu});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [kPrimaryColor.withOpacity(0.2), kBackgroundDark],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.videocam_off_outlined, size: 64, color: Colors.white),
                  ),
                  SizedBox(height: 32),
                  Text(
                    "カメラの権限が必要です",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "※現在はデバッグモードです。\n「強制スタート」を押すと、カメラ権限なしでトレーニング画面を確認できます。",
                    style: TextStyle(
                      color: kTextDarkSecondary,
                      height: 1.6,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 48),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Lexend'),
                      ),
                      onPressed: () {
                        // 【デバッグ用修正】本来は openAppSettings() だが、強制的に実行画面へ飛ばす
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ExecutionScreen(menu: menu)),
                        );
                      },
                      child: Text("強制スタート（デバッグ）"),
                    ),
                  ),
                  SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      // 本当の設定画面に行きたい場合用（予備）
                      openAppSettings();
                    },
                    child: Text(
                      "本来の設定画面を開く",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "戻る",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



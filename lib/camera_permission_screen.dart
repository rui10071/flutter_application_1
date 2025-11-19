import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'theme.dart';
import 'execution_screen.dart'; 
import 'training_model.dart'; 


class CameraPermissionScreen extends StatelessWidget {
  final TrainingMenu menu;


  const CameraPermissionScreen({required this.menu});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kPrimaryColor.withOpacity(0.1), Colors.black],
                  stops: [0.0, 0.6],
                ),
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
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                      border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
                      boxShadow: [BoxShadow(color: kPrimaryColor.withOpacity(0.1), blurRadius: 30)],
                    ),
                    child: Icon(Icons.videocam_off_outlined, size: 64, color: Colors.white),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "カメラの権限が必要です",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Noto Sans JP'
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "AIフォーム解析にはカメラへのアクセスが必要です。\n設定から許可してください。",
                    style: TextStyle(
                      color: Colors.white54,
                      height: 1.6,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 48),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      onPressed: () {
                        openAppSettings();
                      },
                      child: Text("設定を開く", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ExecutionScreen(menu: menu)),
                      );
                    },
                    child: Text(
                      "デバッグ: 強制スタート",
                      style: TextStyle(color: Colors.white24, fontSize: 12),
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



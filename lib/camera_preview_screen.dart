import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'theme.dart';
import 'training_model.dart';
import 'execution_screen.dart';


class CameraPreviewScreen extends StatelessWidget {
  final TrainingMenu menu;


  CameraPreviewScreen({required this.menu});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.grey[900],
              child: Center(
                child: Icon(Icons.videocam_off, color: Colors.white24, size: 64),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 300,
              height: 500,
              decoration: BoxDecoration(
                border: Border.all(color: kPrimaryColor.withOpacity(0.5), width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.person_outline, color: kPrimaryColor.withOpacity(0.3), size: 200),
                  Positioned(
                    bottom: 16,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "全身を枠内に収めてください",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text("カメラ設定", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Spacer(),
                _buildInstructionCard(context),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildInstructionCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("推奨環境", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
              SizedBox(height: 16),
              _buildCheckItem("カメラから1.5〜2m離れてください"),
              _buildCheckItem("明るい場所で行ってください"),
              _buildCheckItem(menu.requiredAngle + "を向いてください"),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ExecutionScreen(menu: menu)),
                  );
                },
                child: Text("準備OK・開始する", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(Icons.check, color: kPrimaryColor, size: 16),
          SizedBox(width: 12),
          Text(text, style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}



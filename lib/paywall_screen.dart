import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'theme.dart';


class PaywallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=2940&auto=format&fit=crop",
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.8),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white54),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(height: 16),
                  Icon(Icons.lock_outline, color: kPrimaryColor, size: 48),
                  SizedBox(height: 24),
                  Text(
                    "プレミアム機能の\nロックを解除",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 32),
                  _buildFeatureItem("AIフォーム解析が無制限"),
                  _buildFeatureItem("詳細な分析レポートと履歴"),
                  _buildFeatureItem("全トレーニングメニュー開放"),
                  _buildFeatureItem("広告の非表示"),
                  Spacer(),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "月額プラン",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text("¥500", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Lexend')),
                            Text(" / 月", style: TextStyle(color: Colors.white70, fontSize: 14)),
                          ],
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.black,
                            minimumSize: Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          onPressed: () {},
                          child: Text("1週間無料トライアルを開始", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "トライアル終了後は自動的に更新されます。\nいつでもキャンセル可能です。",
                          style: TextStyle(color: Colors.white38, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ],
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


  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(color: kPrimaryColor.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(Icons.check, color: kPrimaryColor, size: 16),
          ),
          SizedBox(width: 16),
          Text(text, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}



import 'dart:ui';
import 'package:flutter/material.dart';
import 'theme.dart';
import 'legal_document_screen.dart';


class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}


class _SettingsScreenState extends State<SettingsScreen> {
  bool _voiceEnabled = true;
  bool _hapticEnabled = true;
  bool _notificationEnabled = true;
  String _cameraQuality = "中";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("設定", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSectionTitle("トレーニング設定"),
          _buildGlassContainer(
            child: Column(
              children: [
                _buildSwitchTile("音声フィードバック", "AIの音声指導を有効にする", _voiceEnabled, (v) => setState(() => _voiceEnabled = v)),
                _buildDivider(),
                _buildSwitchTile("振動フィードバック", "重要な通知を振動で知らせる", _hapticEnabled, (v) => setState(() => _hapticEnabled = v)),
                _buildDivider(),
                ListTile(
                  title: Text("カメラ画質", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                  trailing: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _cameraQuality,
                      dropdownColor: Color(0xFF1a2c22),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white54),
                      style: TextStyle(color: Colors.white),
                      onChanged: (val) => setState(() => _cameraQuality = val!),
                      items: ["低", "中", "高"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          _buildSectionTitle("通知"),
          _buildGlassContainer(
            child: _buildSwitchTile("リマインダー", "トレーニング時間を通知する", _notificationEnabled, (v) => setState(() => _notificationEnabled = v)),
          ),
          SizedBox(height: 24),
          _buildSectionTitle("法律・情報"),
          _buildGlassContainer(
            child: Column(
              children: [
                _buildLinkTile("利用規約", () => _openLegal(context, "利用規約", "利用規約の本文...")),
                _buildDivider(),
                _buildLinkTile("プライバシーポリシー", () => _openLegal(context, "プライバシーポリシー", "プライバシーポリシーの本文...")),
                _buildDivider(),
                _buildLinkTile("特定商取引法に基づく表記", () => _openLegal(context, "特定商取引法に基づく表記", _tokushoText)),
              ],
            ),
          ),
          SizedBox(height: 40),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text("アカウントを削除", style: TextStyle(color: Colors.red)),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }


  void _openLegal(BuildContext context, String title, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LegalDocumentScreen(title: title, content: content)),
    );
  }


  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Text(title, style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }


  Widget _buildGlassContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: child,
        ),
      ),
    );
  }


  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.white38, fontSize: 12)),
      value: value,
      onChanged: onChanged,
      activeColor: kPrimaryColor,
      activeTrackColor: kPrimaryColor.withOpacity(0.3),
    );
  }


  Widget _buildLinkTile(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right, color: Colors.white24),
      onTap: onTap,
    );
  }


  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.white.withOpacity(0.1), indent: 16, endIndent: 16);
  }


  final String _tokushoText = """
販売業者: MIRRORSENSE Inc.
代表責任者: 田中 健太
所在地: 東京都渋谷区... (バーチャルオフィス)
電話番号: 050-XXXX-XXXX
メールアドレス: support@mirrorsense.app
販売価格: 月額500円
...
""";
}



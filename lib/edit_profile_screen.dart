import 'package:flutter/material.dart';
import 'theme.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("プロフィールを編集"),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("保存", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SizedBox(height: 16),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundImage: AssetImage("assets/images/shoulderstretch.jpg"),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: Theme.of(context).scaffoldBackgroundColor)
                    ),
                    child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    padding: EdgeInsets.all(6),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          TextField(
            controller: TextEditingController(text: "田中 健太"),
            decoration: InputDecoration(
              labelText: "名前",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: TextEditingController(text: "@kenta-tanaka"),
            enabled: false,
            decoration: InputDecoration(
              labelText: "ユーザーID",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Theme.of(context).disabledColor.withOpacity(0.05),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: TextEditingController(text: "フィットネス愛好家です。フォーム改善のために頑張っています！"),
            maxLines: 4,
            decoration: InputDecoration(
              labelText: "自己紹介",
              alignLabelWithHint: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}


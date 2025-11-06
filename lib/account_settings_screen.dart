import 'package:flutter/material.dart';
import 'theme.dart';

class AccountSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("アカウント設定"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle(context, "アカウント情報"),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.email_outlined, color: kTextDarkSecondary),
                  title: Text("メールアドレス"),
                  subtitle: Text("kenta.tanaka@example.com"),
                  trailing: Icon(Icons.chevron_right, color: kTextDarkSecondary),
                  onTap: () {},
                ),
                Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: Icon(Icons.lock_outline, color: kTextDarkSecondary),
                  title: Text("パスワード変更"),
                  trailing: Icon(Icons.chevron_right, color: kTextDarkSecondary),
                  onTap: () {},
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          _buildSectionTitle(context, "連携サービス"),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.g_mobiledata, color: kTextDarkSecondary, size: 32),
                  title: Text("Google"),
                  subtitle: Text("連携済み"),
                  onTap: () {},
                ),
                Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: Icon(Icons.apple, color: kTextDarkSecondary),
                  title: Text("Apple"),
                  subtitle: Text("未連携"),
                  trailing: TextButton(
                    child: Text("連携する"),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: Icon(Icons.delete_forever_outlined, color: kHighlight),
              title: Text("アカウントを削除", style: TextStyle(color: kHighlight, fontWeight: FontWeight.w500)),
              onTap: () {},
            ),
           ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextDarkSecondary),
      ),
    );
  }
}


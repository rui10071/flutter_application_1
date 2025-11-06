
import 'package:flutter/material.dart';
import 'theme.dart';

class HelpSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ヘルプとサポート"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle(context, "よくある質問 (FAQ)"),
          Card(
            child: Column(
              children: [
                ExpansionTile(
                  leading: Icon(Icons.help_outline, color: kTextDarkSecondary),
                  title: Text("AIフォーム解析がうまく動作しません"),
                  children: <Widget>[
                    ListTile(
                      title: Text("カメラがオンになっていることを確認してください。また、明るい場所で、全身が映るようにスマートフォンを設置してください。"),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0).copyWith(left: 32.0),
                    ),
                  ],
                ),
                _buildDivider(),
                ExpansionTile(
                  leading: Icon(Icons.videocam_off_outlined, color: kTextDarkSecondary),
                  title: Text("動画が再生されません"),
                  children: <Widget>[
                    ListTile(
                      title: Text("インターネット接続が安定していることを確認してください。接続が不安定な場合、動画の読み込みに時間がかかることがあります。"),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0).copyWith(left: 32.0),
                    ),
                  ],
                ),
                _buildDivider(),
                ExpansionTile(
                  leading: Icon(Icons.sync_problem, color: kTextDarkSecondary),
                  title: Text("データが同期されません"),
                  children: <Widget>[
                    ListTile(
                      title: Text("アプリを一度再起動し、再度お試しください。"),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0).copyWith(left: 32.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          _buildSectionTitle(context, "お問い合わせ"),
          Card(
            child: ListTile(
              leading: Icon(Icons.support_agent, color: kTextDarkSecondary),
              title: Text("サポートへのお問い合わせ"),
              subtitle: Text("問題が解決しない場合はこちら"),
              trailing: Icon(Icons.chevron_right, color: kTextDarkSecondary),
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

  Widget _buildDivider() {
    return Divider(height: 1, indent: 16, endIndent: 16);
  }
}


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
                    _buildExpansionContent(
                      "カメラがオンになっていることを確認してください。また、明るい場所で、全身が映るようにスマートフォンを設置してください。"
                    ),
                  ],
                ),
                _buildDivider(),
                ExpansionTile(
                  leading: Icon(Icons.videocam_off_outlined, color: kTextDarkSecondary),
                  title: Text("動画が再生されません"),
                  children: <Widget>[
                    _buildExpansionContent(
                      "インターネット接続が安定していることを確認してください。接続が不安定な場合、動画の読み込みに時間がかかることがあります。"
                    ),
                  ],
                ),
                _buildDivider(),
                ExpansionTile(
                  leading: Icon(Icons.sync_problem, color: kTextDarkSecondary),
                  title: Text("データが同期されません"),
                  children: <Widget>[
                    _buildExpansionContent(
                      "アプリを一度再起動し、再度お試しください。"
                    ),
                  ],
                ),
                _buildDivider(),
                ExpansionTile(
                  leading: Icon(Icons.payment, color: kTextDarkSecondary),
                  title: Text("サブスクリプションの管理方法は？"),
                  children: <Widget>[
                    _buildExpansionContent(
                      "「アカウント設定」>「サブスクリプション」から、現在のプランの確認、変更、または解約手続きが行えます。"
                    ),
                  ],
                ),
                _buildDivider(),
                ExpansionTile(
                  leading: Icon(Icons.money_off, color: kTextDarkSecondary),
                  title: Text("返金は可能ですか？"),
                  children: <Widget>[
                    _buildExpansionContent(
                      "デジタルコンテンツの特性上、原則として返金は受け付けておりません。詳細は利用規約をご確認ください。"
                    ),
                  ],
                ),
                _buildDivider(),
                ExpansionTile(
                  leading: Icon(Icons.person_outline, color: kTextDarkSecondary),
                  title: Text("身長や体重を変更したい"),
                  children: <Widget>[
                    _buildExpansionContent(
                      "「プロフィール」タブの「ステータス」セクションにある身長または体重の項目をタップすることで、いつでも編集が可能です。"
                    ),
                  ],
                ),
                _buildDivider(),
                ExpansionTile(
                  leading: Icon(Icons.history, color: kTextDarkSecondary),
                  title: Text("過去のトレーニング履歴はどこで見れますか？"),
                  children: <Widget>[
                    _buildExpansionContent(
                      "「記録」タブの「トレーニング履歴」セクションから、過去のすべてのトレーニング記録を確認できます。"
                    ),
                  ],
                ),
                _buildDivider(),
                ExpansionTile(
                  leading: Icon(Icons.model_training, color: kTextDarkSecondary),
                  title: Text("「フォーム安定度」とは何ですか？"),
                  children: <Widget>[
                    _buildExpansionContent(
                      "トレーニング中の姿勢のブレや、正しいフォームからの逸脱度合いをAIがスコア化したものです。高い点数ほど、安定したフォームで実行できていることを示します。"
                    ),
                  ],
                ),
                _buildDivider(),
                ExpansionTile(
                  leading: Icon(Icons.videocam_outlined, color: kTextDarkSecondary),
                  title: Text("「推奨アングル」とは何ですか？"),
                  children: <Widget>[
                    _buildExpansionContent(
                      "AIがあなたのフォームを最も正確に解析できる、推奨のカメラアングル（正面、側面など）です。トレーニング開始前に確認し、その角度から全身が映るようにしてください。"
                    ),
                  ],
                ),
                _buildDivider(),
                ExpansionTile(
                  leading: Icon(Icons.notifications_off, color: kTextDarkSecondary),
                  title: Text("リマインダー通知をオフにしたい"),
                  children: <Widget>[
                    _buildExpansionContent(
                      "「プロフィール」タブ > 「設定」 > 「通知設定」から、プッシュ通知やリマインダーのオン・オフを個別に設定できます。"
                    ),
                  ],
                ),
                _buildDivider(),
                ExpansionTile(
                  leading: Icon(Icons.add_circle_outline, color: kTextDarkSecondary),
                  title: Text("自分でトレーニングメニューを作成できますか？"),
                  children: <Widget>[
                    _buildExpansionContent(
                      "現在、カスタムメニューの作成機能は提供しておりません。今後のアップデートで対応を検討しております。"
                    ),
                  ],
                ),
                _buildDivider(),
                ExpansionTile(
                  leading: Icon(Icons.no_accounts, color: kTextDarkSecondary),
                  title: Text("Google/Appleでログインできません"),
                  children: <Widget>[
                    _buildExpansionContent(
                      "お使いのデバイスのOSが最新であるか、またGoogle/Appleのサービスが正常に動作しているかをご確認ください。解決しない場合は、アプリを再インストールしてお試しください。"
                    ),
                  ],
                ),
                _buildDivider(),
                ExpansionTile(
                  leading: Icon(Icons.delete_forever_outlined, color: kTextDarkSecondary),
                  title: Text("アカウントを削除したい"),
                  children: <Widget>[
                    _buildExpansionContent(
                      "「プロフィール」タブ > 「設定」 > 「アカウント設定」の最下部にある「アカウントを削除」から手続きを行ってください。この操作は取り消せません。"
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

  Widget _buildExpansionContent(String text) {
    return ListTile(
      title: Text(text),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0).copyWith(left: 32.0),
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


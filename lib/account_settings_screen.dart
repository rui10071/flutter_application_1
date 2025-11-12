import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';
import 'password_change_screen.dart'; // 新規作成
import 'legal_document_screen.dart'; // 新規作成

class AccountSettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

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
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordChangeScreen()));
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          _buildSectionTitle(context, "外観"),
          Card(
            child: SwitchListTile(
              secondary: Icon(isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined, color: kTextDarkSecondary),
              title: Text("ダークモード"),
              subtitle: Text(isDark ? "オン" : "オフ"),
              value: isDark,
              onChanged: (bool value) {
                ref.read(themeModeProvider.notifier).state = value ? ThemeMode.dark : ThemeMode.light;
              },
              activeColor: kPrimaryColor,
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
          _buildSectionTitle(context, "法務"),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined, color: kTextDarkSecondary),
                  title: Text("プライバシーポリシー"),
                  trailing: Icon(Icons.chevron_right, color: kTextDarkSecondary),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => LegalDocumentScreen(
                        title: "プライバシーポリシー",
                        content: _privacyPolicyText, // 下で定義
                      )
                    ));
                  },
                ),
                Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: Icon(Icons.description_outlined, color: kTextDarkSecondary),
                  title: Text("利用規約"),
                  trailing: Icon(Icons.chevron_right, color: kTextDarkSecondary),
                  onTap: () {
                     Navigator.push(context, MaterialPageRoute(
                      builder: (context) => LegalDocumentScreen(
                        title: "利用規約",
                        content: _termsOfServiceText, // 下で定義
                      )
                    ));
                  },
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

  // 法務関連のダミーテキスト
  final String _privacyPolicyText = """
1. 収集する情報
本アプリは、サービスの提供および改善のため、以下の情報を収集することがあります。
(1) ユーザーが提供する情報：メールアドレス、パスワード、身長、体重、年齢、フィットネス目標
(2) AIフォーム解析により取得する情報：トレーニング中の姿勢データ（骨格情報）。カメラ映像はサーバーに保存されません。
(3) デバイス情報：OSバージョン、デバイスモデル、IPアドレス

2. 情報の利用目的
(1) フォーム解析およびフィードバックの提供のため
(2) パーソナライズされたトレーニング推奨のため
(3) サービスに関する重要なお知らせのため


""";

  final String _termsOfServiceText = """
第1条（本規約への同意）
1. ユーザーは、本利用規約（以下「本規約」といいます。）に同意した場合に限り、本サービスを利用することができます。
2. 本サービスは、フィットネスのフォーム改善を支援するものであり、医療行為、診断、治療を提供するものではありません。

第2条（アカウント）
1. ユーザーは、アカウント登録において、真実かつ正確な情報を提供するものとします。
2. ユーザーは、自己の責任においてアカウント情報を管理するものとし、これを第三者に利用させ、または貸与、譲渡、名義変更、売買等をしてはならないものとします。

...
""";
}


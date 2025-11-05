import 'package:flutter/material.dart';
import 'theme.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.only(bottom: 100),
          children: [
            _buildAppBar(context),
            _buildUserInfo(context),
            _buildStats(context),
            _buildSettingsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 48),
          Text("プロフィール", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundImage: AssetImage("assets/images/shoulderstretch.jpg"),
          ),
          SizedBox(height: 16),
          Text("田中 健太", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text("kenta.tanaka@example.com", style: TextStyle(fontSize: 14, color: kTextDarkSecondary)),
          SizedBox(height: 16),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: kPrimaryColor.withOpacity(0.1),
              foregroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            onPressed: () {},
            child: Text("プロフィールを編集", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildStatCard(context, "175", "cm", "身長", true),
          SizedBox(width: 16),
          _buildStatCard(context, "68", "kg", "体重", true),
          SizedBox(width: 16),
          _buildStatCard(context, "28", "歳", "年齢", false),
        ],
      ),
    );
  }
  
  Widget _buildStatCard(BuildContext context, String value, String unit, String label, bool editable) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: value),
                        TextSpan(text: unit, style: TextStyle(fontSize: 12)),
                      ]
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(label, style: TextStyle(color: kTextDarkSecondary, fontSize: 12)),
                ],
              ),
              if (editable)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Icon(Icons.edit, size: 16, color: kTextDarkSecondary),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Text(
              "設定",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextDarkSecondary),
            ),
          ),
          SizedBox(height: 4),
          _buildSettingItem(context, icon: Icons.person_outline, title: "アカウント設定"),
          _buildSettingItem(context, icon: Icons.notifications_outlined, title: "通知設定"),
          _buildSettingItem(context, icon: Icons.help_outline, title: "ヘルプとサポート"),
          SizedBox(height: 16),
           Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: Icon(Icons.logout, color: kHighlight),
              title: Text("ログアウト", style: TextStyle(color: kHighlight, fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
            ),
           ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, {required IconData icon, required String title}) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: Icon(icon, color: kTextDarkSecondary),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.chevron_right, color: kTextDarkSecondary),
        onTap: () {},
      ),
    );
  }
}


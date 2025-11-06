import 'package:flutter/material.dart';
import 'theme.dart';
import 'login_screen.dart';
import 'account_settings_screen.dart';
import 'notification_settings_screen.dart';
import 'help_support_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildSectionTitle(context, "ステータス"),
              _buildBodyMetrics(context),
              _buildSectionTitle(context, "設定"),
              _buildSettingsList(context),
              SizedBox(height: 32),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: 220.0,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        centerTitle: false,
        title: _buildCollapsedHeader(context),
        background: _buildExpandedHeader(context),
      ),
    );
  }

  Widget _buildCollapsedHeader(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage("assets/images/shoulderstretch.jpg"),
            ),
            SizedBox(width: 12),
            Text(
              "田中 健太",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildExpandedHeader(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0, bottom: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundImage: AssetImage("assets/images/shoulderstretch.jpg"),
            ),
            SizedBox(height: 12),
            Text(
              "田中 健太",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              "kenta.tanaka@example.com",
              style: TextStyle(fontSize: 14, color: kTextDarkSecondary),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
              },
              child: Text("プロフィールを編集", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Lexend')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12, 
          fontWeight: FontWeight.bold, 
          color: kTextDarkSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildBodyMetrics(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? kCardDark : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            _buildMetricTile(context, "身長", "175", "cm", true, () {
              _showEditModal(context, "身長", "175", "cm");
            }),
            Divider(height: 1, indent: 16, endIndent: 16),
            _buildMetricTile(context, "体重", "68", "kg", true, () {
              _showEditModal(context, "体重", "68", "kg");
            }),
            Divider(height: 1, indent: 16, endIndent: 16),
            _buildMetricTile(context, "年齢", "28", "歳", false, null),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(BuildContext context, String label, String value, String unit, bool editable, VoidCallback? onTap) {
    return ListTile(
      title: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kTextDarkSecondary),
              children: [
                TextSpan(text: value, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold)),
                TextSpan(text: " $unit", style: TextStyle(fontSize: 14)),
              ]
            ),
          ),
          if (editable) ...[
            SizedBox(width: 8),
            Icon(Icons.edit_outlined, size: 20, color: kTextDarkSecondary),
          ]
        ],
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _showEditModal(BuildContext context, String title, String initialValue, String unit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("あなたの${title}を入力", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 24),
                TextField(
                  controller: TextEditingController(text: initialValue),
                  decoration: InputDecoration(
                    labelText: title,
                    suffixText: unit,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.number,
                  autofocus: true,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("保存する", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Lexend')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color tileColor = isDark ? kCardDark : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSettingSection(
            context,
            tileColor,
            [
              _buildSettingItem(
                context, 
                icon: Icons.person_outline, 
                title: "アカウント設定",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AccountSettingsScreen()));
                }
              ),
              _buildSettingItem(
                context, 
                icon: Icons.notifications_outlined, 
                title: "通知設定",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationSettingsScreen()));
                }
              ),
            ]
          ),
          SizedBox(height: 16),
          _buildSettingSection(
            context,
            tileColor,
            [
              _buildSettingItem(
                context, 
                icon: Icons.help_outline, 
                title: "ヘルプとサポート",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HelpSupportScreen()));
                }
              ),
              _buildSettingItem(
                context, 
                icon: Icons.info_outline, 
                title: "バージョン情報",
                subtitle: "1.0.0 (プロトタイプ)",
                onTap: () {}
              ),
            ]
          ),
          SizedBox(height: 16),
          _buildSettingSection(
            context,
            tileColor,
            [
              _buildSettingItem(
                context, 
                icon: Icons.logout, 
                title: "ログアウト",
                color: kHighlight,
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
                  );
                }
              ),
            ]
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSection(BuildContext context, Color tileColor, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
        separatorBuilder: (context, index) => Divider(height: 1, indent: 56, endIndent: 16),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, {required IconData icon, required String title, String? subtitle, Color? color, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: color ?? kTextDarkSecondary),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: color)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: kTextDarkSecondary)) : null,
      trailing: (color == null) ? Icon(Icons.chevron_right, color: kTextDarkSecondary) : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}


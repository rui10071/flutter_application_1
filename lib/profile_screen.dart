import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart'; // kTextDarkSecondary, kPrimaryColor, kCardDark, kHighlight などの定義
import 'login_screen.dart';
import 'account_settings_screen.dart';
import 'notification_settings_screen.dart';
import 'help_support_screen.dart';
import 'edit_profile_screen.dart';

// UserProfileとUserProfileNotifierは変更なし
class UserProfile {
  final String height;
  final String weight;
  final String age;
  UserProfile({this.height = "175", this.weight = "68", this.age = "28"});

  UserProfile copyWith({String? height, String? weight, String? age}) {
    return UserProfile(
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
    );
  }
}

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(UserProfile());

  void updateHeight(String newHeight) {
    state = state.copyWith(height: newHeight);
  }

  void updateWeight(String newWeight) {
    state = state.copyWith(weight: newWeight);
  }
}

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});

class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true, // AppBarの背後までbodyを拡張
      appBar: AppBar(
        backgroundColor: Colors.transparent, // AppBarの背景を透明に
        elevation: 0, // 影をなくす
        foregroundColor: Colors.white, // アイコンとテキストの色を白に（背景が暗い想定のため）
      ),
      body: Stack(
        children: [
          // 背景のグラデーション
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [kPrimaryColor, Theme.of(context).scaffoldBackgroundColor], // kPrimaryColorから背景色へ
                stops: [0.0, 0.4], // グラデーションの開始と終了位置
              ),
            ),
          ),
          // スクロール可能なコンテンツ
          SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildHeaderSection(context),
                _buildBodyMetricsSection(context, ref),
                _buildSettingsSection(context),
                _buildLogoutSection(context),
                SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ヘッダーセクション（アバター、名前、メール、編集ボタン）
  Widget _buildHeaderSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("assets/images/shoulderstretch.jpg"),
            backgroundColor: Colors.white.withOpacity(0.8), // アバターの背景色
          ),
          SizedBox(height: 16),
          Text(
            "田中 健太",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // 名前を白に
                ),
          ),
          SizedBox(height: 4),
          Text(
            "kenta.tanaka@example.com",
            style: TextStyle(fontSize: 14, color: Colors.white70), // メールアドレスを薄い白に
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2), // 半透明の白ボタン
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
            },
            icon: Icon(Icons.edit_outlined, size: 20),
            label: Text("プロフィールを編集", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Lexend')),
          ),
        ],
      ),
    );
  }

  // ボディメトリクス（身長、体重、年齢）セクション
  Widget _buildBodyMetricsSection(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = isDark ? kCardDark : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, "ステータス"),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildMetricCard(context, ref, "身長", userProfile.height, "cm")),
              SizedBox(width: 16),
              Expanded(child: _buildMetricCard(context, ref, "体重", userProfile.weight, "kg")),
              SizedBox(width: 16),
              Expanded(child: _buildMetricCard(context, ref, "年齢", userProfile.age, "歳", editable: false)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, WidgetRef ref, String label, String value, String unit, {bool editable = true}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = isDark ? kCardDark : Colors.white;

    return GestureDetector(
      onTap: editable ? () => _showEditModal(context, ref, label, value, unit) : null,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: TextStyle(fontSize: 14, color: kTextDarkSecondary)),
                if (editable) Icon(Icons.edit_outlined, size: 18, color: kTextDarkSecondary),
              ],
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
                children: [
                  TextSpan(text: value),
                  TextSpan(text: " $unit", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: kTextDarkSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 設定セクション
  Widget _buildSettingsSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color tileColor = isDark ? kCardDark : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, "設定"),
          SizedBox(height: 12),
          _buildSettingCard(
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
          _buildSettingCard(
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
        ],
      ),
    );
  }

  // ログアウトセクション
  Widget _buildLogoutSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color tileColor = isDark ? kCardDark : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: _buildSettingCard(
        context,
        tileColor,
        [
          _buildSettingItem(
            context, 
            icon: Icons.logout, 
            title: "ログアウト",
            color: kHighlight, // ログアウトは強調色で
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
    );
  }

  // 共通部品: セクションタイトル
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13, 
          fontWeight: FontWeight.bold, 
          color: kTextDarkSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // 共通部品: 設定カード（グループ化された設定項目）
  Widget _buildSettingCard(BuildContext context, Color cardColor, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
        separatorBuilder: (context, index) => Divider(height: 1, indent: 56, endIndent: 16, color: Theme.of(context).dividerColor.withOpacity(0.5)),
      ),
    );
  }

  // 共通部品: 設定項目（ListTile）
  Widget _buildSettingItem(BuildContext context, {required IconData icon, required String title, String? subtitle, Color? color, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: color ?? kTextDarkSecondary),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: color)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: kTextDarkSecondary, fontSize: 13)) : null,
      trailing: (color == null) ? Icon(Icons.chevron_right, color: kTextDarkSecondary) : null,
      onTap: onTap,
      minLeadingWidth: 20, // leadingアイコンの最小幅
    );
  }

  // 共通部品: 体重/身長編集モーダル
  void _showEditModal(BuildContext context, WidgetRef ref, String title, String initialValue, String unit) {
    final controller = TextEditingController(text: initialValue);

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
                  controller: controller,
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
                    if (title == "身長") {
                      ref.read(userProfileProvider.notifier).updateHeight(controller.text);
                    } else if (title == "体重") {
                      ref.read(userProfileProvider.notifier).updateWeight(controller.text);
                    }
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
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';
import 'login_screen.dart';
import 'account_settings_screen.dart';
import 'notification_settings_screen.dart';
import 'help_support_screen.dart';
import 'edit_profile_screen.dart';
import 'onboarding_goal_screen.dart'; 
import 'version_info_screen.dart';


class UserProfile {
  final String name;
  final String email;
  final String height;
  final String weight;
  final String age;
  final String goal;


  UserProfile({
    this.name = "田中 健太",
    this.email = "kenta.tanaka@example.com",
    this.height = "175", 
    this.weight = "68", 
    this.age = "28", 
    this.goal = "フォームを改善したい"
  });


  UserProfile copyWith({String? name, String? email, String? height, String? weight, String? age, String? goal}) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      goal: goal ?? this.goal,
    );
  }
}


class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(UserProfile());


  void updateName(String newName) {
    state = state.copyWith(name: newName);
  }


  void updateHeight(String newHeight) {
    state = state.copyWith(height: newHeight);
  }


  void updateWeight(String newWeight) {
    state = state.copyWith(weight: newWeight);
  }


  void updateAge(String newAge) {
    state = state.copyWith(age: newAge);
  }


  void updateGoal(String newGoal) {
    state = state.copyWith(goal: newGoal);
  }
}


final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});


class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;


    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        foregroundColor: isDark ? Colors.white : kTextLight, 
        actions: [
           IconButton(
             icon: Icon(Icons.settings_outlined),
             onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => AccountSettingsScreen()));
             },
           ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark 
                  ? [kPrimaryColor, theme.scaffoldBackgroundColor] 
                  : [kPrimaryColor, theme.scaffoldBackgroundColor],
                stops: [0.0, 0.4], 
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildHeaderSection(context, ref),
                _buildBodyMetricsSection(context, ref),
                _buildGoalSection(context, ref),
                _buildSettingsSection(context),
                _buildLogoutSection(context),
                SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildHeaderSection(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/shoulderstretch.jpg"),
              backgroundColor: Colors.white.withOpacity(0.8), 
            ),
          ),
          SizedBox(height: 16),
          Text(
            userProfile.name,
            style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : kTextLight, 
                ),
          ),
          SizedBox(height: 4),
          Text(
            userProfile.email,
            style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : kTextLightSecondary), 
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.white.withOpacity(0.2) : kPrimaryColor.withOpacity(0.1), 
              foregroundColor: isDark ? Colors.white : kPrimaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
              side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
            },
            icon: Icon(Icons.edit_outlined, size: 18),
            label: Text("プロフィールを編集", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Lexend')),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionContainer(BuildContext context, {required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        border: isDark ? null : Border.all(color: Colors.black.withOpacity(0.8), width: 1.0),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: child,
    );
  }


  Widget _buildBodyMetricsSection(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    return _buildSectionContainer(
      context,
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
              Expanded(child: _buildMetricCard(context, ref, "年齢", userProfile.age, "歳")),
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
                Text(label, style: TextStyle(fontSize: 12, color: kTextDarkSecondary, fontWeight: FontWeight.bold)),
                if (editable) Icon(Icons.edit_outlined, size: 16, color: kTextDarkSecondary),
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold, 
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    height: 1.0,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: kTextDarkSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildGoalSection(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color tileColor = isDark ? kCardDark : Colors.white;


    return _buildSectionContainer(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, "フィットネス目標"),
          SizedBox(height: 12),
          _buildSettingCard(
            context,
            tileColor,
            [
              _buildSettingItem(
                context,
                icon: Icons.flag_outlined,
                title: "現在の目標",
                subtitle: userProfile.goal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OnboardingGoalScreen(isChangingGoal: true)),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildSettingsSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color tileColor = isDark ? kCardDark : Colors.white;


    return _buildSectionContainer(
      context,
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
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => VersionInfoScreen()));
                }
              ),
            ]
          ),
        ],
      ),
    );
  }


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
    );
  }


  Widget _buildSectionTitle(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13, 
          fontWeight: FontWeight.bold, 
          color: isDark ? kTextDarkSecondary : kTextLightSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }


  Widget _buildSettingCard(BuildContext context, Color cardColor, List<Widget> children) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.1 : 0.05),
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
        separatorBuilder: (context, index) => Divider(height: 1, indent: 56, endIndent: 16, color: Colors.white.withOpacity(0.3)),
      ),
    );
  }


  Widget _buildSettingItem(BuildContext context, {required IconData icon, required String title, String? subtitle, Color? color, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: color ?? kTextDarkSecondary),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: color)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: kTextDarkSecondary, fontSize: 13)) : null,
      trailing: (color == null) ? Icon(Icons.chevron_right, color: kTextDarkSecondary) : null,
      onTap: onTap,
      minLeadingWidth: 20, 
    );
  }


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
                    } else if (title == "年齢") {
                      ref.read(userProfileProvider.notifier).updateAge(controller.text);
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



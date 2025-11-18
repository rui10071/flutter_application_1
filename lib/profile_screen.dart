import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';
import 'login_or_signup_screen.dart'; 
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
  final String goal;


  UserProfile({
    this.name = "田中 健太",
    this.email = "kenta.tanaka@example.com",
    this.height = "175", 
    this.weight = "68", 
    this.goal = "フォームを改善したい"
  });


  UserProfile copyWith({String? name, String? email, String? height, String? weight, String? goal}) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      height: height ?? this.height,
      weight: weight ?? this.weight,
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
              gradient: isDark 
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [kPrimaryColor, theme.scaffoldBackgroundColor],
                      stops: [0.0, 0.4], 
                    )
                  : null,
              color: isDark ? null : kBackgroundLight,
            ),
          ),
          SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildHeaderSection(context, ref, isDark),
                _buildBodyMetricsSection(context, ref, isDark),
                _buildGoalSection(context, ref, isDark),
                _buildSettingsSection(context, isDark),
                _buildLogoutSection(context, isDark),
                SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildHeaderSection(BuildContext context, WidgetRef ref, bool isDark) {
    final userProfile = ref.watch(userProfileProvider);
    final textColor = isDark ? Colors.white : kTextLight;


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isDark ? Colors.white : kPrimaryColor, width: 4),
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
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor, 
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
              side: BorderSide(color: isDark ? Colors.white.withOpacity(0.3) : kPrimaryColor, width: 1),
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
  
  Widget _buildSectionContainer(BuildContext context, {required Widget child, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: isDark ? Colors.transparent : Colors.white,
        border: isDark ? null : Border.all(color: Colors.grey.shade300, width: 1.0),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: child,
    );
  }


  Widget _buildBodyMetricsSection(BuildContext context, WidgetRef ref, bool isDark) {
    final userProfile = ref.watch(userProfileProvider);
    return _buildSectionContainer(
      context,
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, "ステータス", isDark),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildMetricCard(context, ref, "身長", userProfile.height, "cm", isDark)),
              SizedBox(width: 16),
              Expanded(child: _buildMetricCard(context, ref, "体重", userProfile.weight, "kg", isDark)),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildMetricCard(BuildContext context, WidgetRef ref, String label, String value, String unit, bool isDark) {
    final Color cardColor = isDark ? kCardDark : Colors.grey[100]!;
    final Color textColor = isDark ? Colors.white : kTextLight;


    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: isDark ? kTextDarkSecondary : kTextLightSecondary, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold, 
                  color: textColor,
                  height: 1.0,
                ),
              ),
              SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: isDark ? kTextDarkSecondary : kTextLightSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildGoalSection(BuildContext context, WidgetRef ref, bool isDark) {
    final userProfile = ref.watch(userProfileProvider);
    final Color tileColor = isDark ? kCardDark : Colors.grey[100]!;


    return _buildSectionContainer(
      context,
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, "フィットネス目標", isDark),
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
                isDark: isDark,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OnboardingGoalScreen(isChangingGoal: true)),
                  );
                },
              ),
            ],
            isDark
          ),
        ],
      ),
    );
  }


  Widget _buildSettingsSection(BuildContext context, bool isDark) {
    final Color tileColor = isDark ? kCardDark : Colors.grey[100]!;


    return _buildSectionContainer(
      context,
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, "設定", isDark),
          SizedBox(height: 12),
          _buildSettingCard(
            context,
            tileColor,
            [
              _buildSettingItem(
                context, 
                icon: Icons.person_outline, 
                title: "アカウント設定",
                isDark: isDark,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AccountSettingsScreen()));
                }
              ),
              _buildSettingItem(
                context, 
                icon: Icons.notifications_outlined, 
                title: "通知設定",
                isDark: isDark,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationSettingsScreen()));
                }
              ),
            ],
            isDark
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
                isDark: isDark,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HelpSupportScreen()));
                }
              ),
              _buildSettingItem(
                context, 
                icon: Icons.info_outline, 
                title: "バージョン情報",
                subtitle: "1.0.0 (プロトタイプ)",
                isDark: isDark,
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => VersionInfoScreen()));
                }
              ),
            ],
            isDark
          ),
        ],
      ),
    );
  }


  Widget _buildLogoutSection(BuildContext context, bool isDark) {
    final Color tileColor = isDark ? kCardDark : Colors.grey[100]!;


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
            isDark: isDark,
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginOrSignupScreen()),
                (route) => false,
              );
            }
          ),
        ],
        isDark
      ),
    );
  }


  Widget _buildSectionTitle(BuildContext context, String title, bool isDark) {
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


  Widget _buildSettingCard(BuildContext context, Color cardColor, List<Widget> children, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
        separatorBuilder: (context, index) => Divider(height: 1, indent: 56, endIndent: 16, color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[300]),
      ),
    );
  }


  Widget _buildSettingItem(BuildContext context, {required IconData icon, required String title, String? subtitle, Color? color, required bool isDark, required VoidCallback onTap}) {
    final textColor = color ?? (isDark ? Colors.white : kTextLight);
    
    return ListTile(
      leading: Icon(icon, color: color ?? (isDark ? kTextDarkSecondary : kTextLightSecondary)),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: textColor)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: isDark ? kTextDarkSecondary : kTextLightSecondary, fontSize: 13)) : null,
      trailing: (color == null) ? Icon(Icons.chevron_right, color: isDark ? kTextDarkSecondary : kTextLightSecondary) : null,
      onTap: onTap,
      minLeadingWidth: 20, 
    );
  }
}



import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'theme.dart';
import 'login_or_signup_screen.dart'; 
import 'account_settings_screen.dart';
import 'notification_settings_screen.dart';
import 'help_support_screen.dart';
import 'edit_profile_screen.dart';
import 'onboarding_goal_screen.dart'; 
import 'version_info_screen.dart';
import 'paywall_screen.dart'; 


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


class ProfileScreen extends ConsumerStatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}


class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad),
    );
    _controller.forward();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        actions: [
           IconButton(
             icon: Icon(Icons.settings_outlined, color: Colors.white),
             onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => AccountSettingsScreen()));
             },
           ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: "https://images.unsplash.com/photo-1555680202-c86f0e12f086?q=80&w=2940&auto=format&fit=crop",
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.black),
              errorWidget: (context, url, error) => Container(color: Color(0xFF122017)),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                    Colors.black,
                  ],
                  stops: [0.0, 0.6, 1.0], 
                ),
              ),
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildHeaderSection(context, ref),
                  _buildPremiumCard(context), 
                  _buildBodyMetricsSection(context, ref),
                  _buildGoalSection(context, ref),
                  _buildSettingsSection(context),
                  _buildLogoutSection(context),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPremiumCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PaywallScreen()));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kPrimaryColor.withOpacity(0.2), kPrimaryColor.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: kPrimaryColor.withOpacity(0.5)),
                boxShadow: [BoxShadow(color: kPrimaryColor.withOpacity(0.1), blurRadius: 12)],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.star, color: Colors.black, size: 20),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("プレミアムプランに加入", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 4),
                        Text("全ての機能が無制限で使い放題", style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: kPrimaryColor, size: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildHeaderSection(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kPrimaryColor, width: 3),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: "https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=2080&auto=format&fit=crop",
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.grey[900], child: Icon(Icons.person, color: Colors.white54)),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[900],
                  child: Icon(Icons.person, size: 50, color: Colors.white54),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            userProfile.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white, 
              fontSize: 24,
            ),
          ),
          SizedBox(height: 4),
          Text(
            userProfile.email,
            style: TextStyle(fontSize: 14, color: Colors.white54), 
          ),
          SizedBox(height: 24),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: kPrimaryColor,
              side: BorderSide(color: kPrimaryColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
            },
            icon: Icon(Icons.edit_outlined, size: 18),
            label: Text("プロフィール編集", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionContainer(BuildContext context, {required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }


  Widget _buildBodyMetricsSection(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    return _buildSectionContainer(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("ステータス"),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildMetricCard(context, "身長", userProfile.height, "cm")),
              SizedBox(width: 16),
              Expanded(child: _buildMetricCard(context, "体重", userProfile.weight, "kg")),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildMetricCard(BuildContext context, String label, String value, String unit) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.white54, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: Colors.white,
                  fontFamily: 'Lexend',
                  fontSize: 24,
                  height: 1.0,
                ),
              ),
              SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white54),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildGoalSection(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);


    return _buildSectionContainer(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("現在の目標"),
          SizedBox(height: 12),
          _buildSettingItem(
            context,
            icon: Icons.flag_outlined,
            title: "目標設定",
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
    );
  }


  Widget _buildSettingsSection(BuildContext context) {
    return _buildSectionContainer(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("設定"),
          SizedBox(height: 12),
          _buildSettingItem(
            context, 
            icon: Icons.person_outline, 
            title: "アカウント設定",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AccountSettingsScreen()));
            }
          ),
          _buildDivider(),
          _buildSettingItem(
            context, 
            icon: Icons.notifications_outlined, 
            title: "通知設定",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationSettingsScreen()));
            }
          ),
          _buildDivider(),
          _buildSettingItem(
            context, 
            icon: Icons.help_outline, 
            title: "ヘルプとサポート",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HelpSupportScreen()));
            }
          ),
          _buildDivider(),
          _buildSettingItem(
            context, 
            icon: Icons.info_outline, 
            title: "バージョン情報",
            subtitle: "1.0.0 (Beta)",
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => VersionInfoScreen()));
            }
          ),
        ],
      ),
    );
  }


  Widget _buildLogoutSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: _buildSectionContainer(
        context,
        child: _buildSettingItem(
          context, 
          icon: Icons.logout, 
          title: "ログアウト",
          color: kHighlight, 
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginOrSignupScreen()),
              (route) => false,
            );
          }
        ),
      ),
    );
  }


  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14, 
        fontWeight: FontWeight.bold, 
        color: Colors.white70,
      ),
    );
  }


  Widget _buildDivider() {
    return Divider(height: 16, indent: 48, color: Colors.white.withOpacity(0.1));
  }


  Widget _buildSettingItem(BuildContext context, {required IconData icon, required String title, String? subtitle, Color? color, required VoidCallback onTap}) {
    final textColor = color ?? Colors.white;
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: color ?? Colors.white54, size: 24),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: textColor, fontSize: 16)),
                  if (subtitle != null)
                    Text(subtitle, style: TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
            ),
            if (color == null) Icon(Icons.chevron_right, color: Colors.white24, size: 20),
          ],
        ),
      ),
    );
  }
}



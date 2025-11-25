import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart'; 
import 'theme.dart';
import 'profile_screen.dart'; 


class EditProfileScreen extends ConsumerStatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}


class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;


  @override
  void initState() {
    super.initState();
    final userProfile = ref.read(userProfileProvider);
    _nameController = TextEditingController(text: userProfile.name);
    _emailController = TextEditingController(text: userProfile.email);
    _heightController = TextEditingController(text: userProfile.height);
    _weightController = TextEditingController(text: userProfile.weight);
  }


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("プロフィール編集", style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                ref.read(userProfileProvider.notifier).updateName(_nameController.text);
                ref.read(userProfileProvider.notifier).updateHeight(_heightController.text);
                ref.read(userProfileProvider.notifier).updateWeight(_weightController.text);
                Navigator.pop(context);
              },
              child: Text("保存", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Lexend', letterSpacing: 1.0)),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: kPrimaryColor.withOpacity(0.5)),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: "https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=2080&auto=format&fit=crop",
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(color: Colors.grey[900]),
                            errorWidget: (context, url, error) => Icon(Icons.person, color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: kPrimaryColor.withOpacity(0.4), blurRadius: 8)],
                          ),
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, color: Colors.black, size: 20),
                            onPressed: () {},
                            constraints: BoxConstraints.tightFor(width: 36, height: 36),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                _buildGlassTextField("名前", _nameController),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _buildGlassTextField("身長", _heightController, suffix: "cm", isNumber: true)),
                    SizedBox(width: 20),
                    Expanded(child: _buildGlassTextField("体重", _weightController, suffix: "kg", isNumber: true)),
                  ],
                ),
                SizedBox(height: 20),
                _buildGlassTextField("メールアドレス", _emailController, enabled: false),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildGlassTextField(String label, TextEditingController controller, {String? suffix, bool isNumber = false, bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white54, fontSize: 12, fontFamily: 'Lexend', fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: TextFormField(
              controller: controller,
              enabled: enabled,
              keyboardType: isNumber ? TextInputType.number : TextInputType.text,
              style: TextStyle(color: enabled ? Colors.white : Colors.white38, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                suffixText: suffix,
                suffixStyle: TextStyle(color: Colors.white54, fontSize: 12),
                filled: true,
                fillColor: enabled ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.02),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                enabledBorder: InputBorder.none,
                focusedBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kPrimaryColor, width: 1),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}



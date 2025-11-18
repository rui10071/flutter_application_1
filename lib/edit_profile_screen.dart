import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : kTextLight;
    final hintColor = isDark ? kTextDarkSecondary : kTextLightSecondary;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("プロフィールを編集", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: textColor),
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
              child: Text("保存", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SizedBox(height: 16),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundImage: AssetImage("assets/images/shoulderstretch.jpg"),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: Theme.of(context).scaffoldBackgroundColor)
                    ),
                    child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    padding: EdgeInsets.all(6),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          TextField(
            controller: _nameController,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              labelText: "名前",
              labelStyle: TextStyle(color: hintColor),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: kPrimaryColor),
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _heightController,
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "身長",
                    suffixText: "cm",
                    labelStyle: TextStyle(color: hintColor),
                    suffixStyle: TextStyle(color: hintColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _weightController,
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "体重",
                    suffixText: "kg",
                    labelStyle: TextStyle(color: hintColor),
                    suffixStyle: TextStyle(color: hintColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          TextField(
            controller: _emailController,
            enabled: false,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              labelText: "メールアドレス",
              labelStyle: TextStyle(color: hintColor),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200,
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



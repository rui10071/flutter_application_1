
import 'package:flutter/material.dart';
import 'theme.dart';

class NotificationSettingsScreen extends StatefulWidget {
  @override
  _NotificationSettingsScreenState createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("通知設定"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle(context, "通知チャネル"),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(Icons.phone_android, color: kTextDarkSecondary),
                  title: Text("プッシュ通知"),
                  subtitle: Text("リマインダーやAIフィードバック"),
                  value: _pushNotifications,
                  onChanged: (bool value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                  },
                  activeColor: kPrimaryColor,
                ),
                Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  secondary: Icon(Icons.mail_outline, color: kTextDarkSecondary),
                  title: Text("メール通知"),
                  subtitle: Text("週次レポートやお知らせ"),
                  value: _emailNotifications,
                  onChanged: (bool value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                  },
                  activeColor: kPrimaryColor,
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          _buildSectionTitle(context, "通知のタイミング"),
          Card(
            child: ListTile(
              leading: Icon(Icons.schedule, color: kTextDarkSecondary),
              title: Text("トレーニングリマインダー"),
              subtitle: Text("毎日 19:00"),
              trailing: Icon(Icons.chevron_right, color: kTextDarkSecondary),
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
}


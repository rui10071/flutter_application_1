import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuB73AL1PrKE6BlVWRrE6_7nu2zNita5A_qkkcviqvO8M_bRe-b9wPKL2dsiieotdU8mHzJ-Bd-h_xSI-zfbfR0G4lVqL8DLW78t18pKDDWgJEtFQOyf-ijMWIPg3h6fLPwsr2UEcSc3GDR84AsmVeUkBzuIAP1fjVPaQXd_r2A_ZYyVUmjJ0dGzi24SliC4s-X-l8zI7SHJnrlj7zSVWttFGUJ8JQmwx_stGQMXhfv8Xc2AZnWXNqiof-wre2-B6WpUmezhiyUay4s",
                  height: 64,
                  width: 64,
                ),
                SizedBox(height: 24),
                Text(
                  "おかえりなさい",
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 32),
                _buildTextField(
                  context,
                  label: "メールアドレス",
                  value: "kenta.tanaka@example.com",
                  isDark: isDark,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  context,
                  label: "パスワード",
                  value: "dummyPassword",
                  isDark: isDark,
                  isPassword: true,
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Lexend'),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Text("ログイン"),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "パスワードを忘れましたか？",
                    style: TextStyle(color: theme.primaryColor, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, {required String label, required String value, required bool isDark, bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          obscureText: isPassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}


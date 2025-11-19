import 'package:flutter/material.dart';
import 'theme.dart';

class PasswordChangeScreen extends StatefulWidget {
  @override
  _PasswordChangeScreenState createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'パスワードを入力してください';
    }
    if (value.length < 6) {
      return 'パスワードは6文字以上で入力してください';
    }
    return null;
  }

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("パスワード変更"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "現在のパスワード",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (val) => (val == null || val.isEmpty) ? "入力してください" : null,
              onChanged: (value) => _validateForm(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            SizedBox(height: 16),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "新しいパスワード",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: _validatePassword,
              onChanged: (value) => _validateForm(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            SizedBox(height: 16),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "新しいパスワード（確認）",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: _validatePassword,
              onChanged: (value) => _validateForm(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isButtonEnabled ? kPrimaryColor : Colors.grey[600],
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Lexend'),
              ),
              onPressed: _isButtonEnabled ? () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context);
                }
              } : null,
              child: Text("保存する"),
            ),
          ],
        ),
      ),
    );
  }
}


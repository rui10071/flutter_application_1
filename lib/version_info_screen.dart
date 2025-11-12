import 'package:flutter/material.dart';
import 'theme.dart';

class VersionInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("バージョン情報"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/Benchpress_logo.jpg",
                height: 360,
                width: 360,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 24),
              Text(
                "MIRRORSENSE",
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "バージョン 1.0.0 (プロトタイプ)",
                style: theme.textTheme.titleMedium?.copyWith(color: kTextDarkSecondary),
              ),
              Spacer(),
              Text(
                "© 2025 MIRRORSENSE. All rights reserved.",
                style: theme.textTheme.bodySmall?.copyWith(color: kTextDarkSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


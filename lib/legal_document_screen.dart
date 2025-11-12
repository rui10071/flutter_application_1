import 'package:flutter/material.dart';
import 'theme.dart';

class LegalDocumentScreen extends StatelessWidget {
  final String title;
  final String content;

  LegalDocumentScreen({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          content,
          style: TextStyle(height: 1.6, color: Theme.of(context).brightness == Brightness.dark ? kTextDark : kTextLight),
        ),
      ),
    );
  }
}


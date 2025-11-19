import 'package:flutter/material.dart';
import 'theme.dart';


class LegalDocumentScreen extends StatelessWidget {
  final String title;
  final String content;


  LegalDocumentScreen({required this.title, required this.content});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title, style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          content,
          style: TextStyle(
            height: 1.8, 
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}


